import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/filter_transaction_waste.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/entities/waste.dart';
import '../../../domain/usecase/get_transactions_filter.dart';

part 'report_bloc.freezed.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetTransactionsFilter _getTransactionsFilter;
  ReportBloc(this._getTransactionsFilter) : super(ReportState.initial()) {
    on<ReportEvent>((event, emit) async {
      await event.when(
        chooseTimeRange: (timeSpan) => _handleChooseTimeRange(emit, timeSpan),
        chooseVillage: (village) => _handleChooseVillage(emit, village),
      );
    });
  }

  Future<void> _handleChooseTimeRange(Emitter<ReportState> emit, TimeSpan timeSpan) async {
    emit(state.copyWith(isLoading: true, timeSpan: timeSpan));
    await processReport(emit, timeSpan, state.village);
  }

  Future<void> _handleChooseVillage(Emitter<ReportState> emit, String village) async {
    emit(state.copyWith(isLoading: true, village: village));
    await processReport(emit, state.timeSpan, village);
  }

  Future<void> processReport(Emitter<ReportState> emit, TimeSpan timeSpan, String village) async {
    FilterTransactionWaste filter = FilterTransactionWaste(
      startEpoch: timeSpan.start,
      endEpoch: timeSpan.end,
      villages: [village],
    );

    final failureOrSuccess = await _getTransactionsFilter(filter);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (transactions) {
        int totalOrganic = 0;
        int totalInorganic = 0;
        int totalOrganicPrice = 0;
        int totalInorganicPrice = 0;
        int totalOrganicBalance = 0;
        int totalInorganicBalance = 0;
        int balance = 0;

        List<RowReport> rowsReport = [];

        for (var transaction in transactions) {
          if (transaction.isVerified == true) {
            totalOrganic += transaction.totalOrganicWeight;
            totalInorganic += transaction.totalInorganicWeight;
            totalOrganicPrice += transaction.totalOrganicPrice;
            totalInorganicPrice += transaction.totalInorganicPrice;
          }

          if (transaction.totalPrice != 0) {
            balance += transaction.totalPrice;
          }

          int existingIndex =
              rowsReport.indexWhere((row) => row.rt == transaction.warga.rt && row.rw == transaction.warga.rw);
          if (existingIndex != -1) {
            RowReport existingRow = rowsReport[existingIndex];
            // Update the existingRow with new data from transaction
            if (transaction.totalWeight != 0) {
              existingRow = existingRow.copyWith(
                waste: Waste(
                  organic: transaction.totalOrganicWeight + existingRow.waste.organic,
                  inorganic: transaction.totalInorganicWeight + existingRow.waste.inorganic,
                ),
              );
            }

            rowsReport[existingIndex] = existingRow;
          } else {
            Waste rowWaste =
                Waste(organic: transaction.totalOrganicWeight, inorganic: transaction.totalInorganicWeight);
            int rowWithdrawBalance = 0;
            rowsReport.add(RowReport(
              rt: transaction.warga.rt,
              rw: transaction.warga.rw,
              waste: rowWaste,
              withdrawBalance: rowWithdrawBalance,
            ));
          }
        }

        int totalWasteStored = totalOrganic + totalInorganic;

        TotalRowReport totalRowReport = TotalRowReport(
          waste: Waste(organic: totalOrganic, inorganic: totalInorganic),
          withdrawBalance: 0,
          sumWaste: totalWasteStored,
        );

        /// Sorting berdasarkan RW dulu baru RT
        rowsReport.sort((a, b) {
          int rwComparison = a.rw.compareTo(b.rw);
          if (rwComparison != 0) {
            return rwComparison;
          } else {
            return a.rt.compareTo(b.rt);
          }
        });

        Report report = Report(
          createdAt: DateTime.now().millisecondsSinceEpoch,
          createdAtCity: 'Semarang',
          village: village,
          rowsReport: rowsReport,
          total: totalRowReport,
          timeSpan: timeSpan.copyWith(end: timeSpan.end - 1000),
        );

        emit(state.copyWith(
          isLoading: false,
          failure: none(),
          report: optionOf(report),
          totalInorganic: AppHelper.formatToThousandsInt(totalInorganic),
          totalOrganic: AppHelper.formatToThousandsInt(totalOrganic),
          totalOrganicBalance: AppHelper.formatToThousandsInt(totalOrganicBalance),
          totalInorganicBalance: AppHelper.formatToThousandsInt(totalInorganicBalance),
          totalWasteStored: AppHelper.formatToThousandsInt(totalWasteStored),
          totalWithdrawBalance: AppHelper.formatToThousandsInt(0),
        ));
      },
    );
  }
}
