import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../core/utils/app_helper.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/entities/waste.dart';
import '../../../domain/usecase/staff/get_transaction_by_time_span.dart';

part 'report_bloc.freezed.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetTransactionsByTimeSpan _getTransactionsByTimeSpan;
  ReportBloc(this._getTransactionsByTimeSpan) : super(ReportState.initial()) {
    on<ReportEvent>((event, emit) async {
      await event.when(
        chooseTimeRange: (timeSpan) => _handleChooseTimeRange(emit, timeSpan),
      );
    });
  }

  Future<void> _handleChooseTimeRange(Emitter<ReportState> emit, TimeSpan timeSpan) async {
    emit(state.copyWith(isLoading: true));

    final failureOrSuccess = await _getTransactionsByTimeSpan(timeSpan);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (transactions) {
        int totalOrganic = 0;
        int totalInorganic = 0;
        int totalOrganicBalance = 0;
        int totalInorganicBalance = 0;
        int withdrawBalance = 0;

        List<RowReport> rowsReport = [];

        for (var transaction in transactions) {
          if (transaction.storeWaste != null) {
            totalOrganic += transaction.storeWaste!.waste.organic;
            totalInorganic += transaction.storeWaste!.waste.inorganic;
            totalOrganicBalance += transaction.storeWaste!.wasteBalance.organic;
            totalInorganicBalance += transaction.storeWaste!.wasteBalance.inorganic;
          }

          if (transaction.withdrawnBalance != null) {
            withdrawBalance += transaction.withdrawnBalance!.withdrawn;
          }

          int existingIndex =
              rowsReport.indexWhere((row) => row.rt == transaction.user.rt && row.rw == transaction.user.rw);
          if (existingIndex != -1) {
            RowReport existingRow = rowsReport[existingIndex];
            // Update the existingRow with new data from transaction
            if (transaction.storeWaste != null) {
              existingRow = existingRow.copyWith(
                waste: Waste(
                  organic: transaction.storeWaste!.waste.organic + existingRow.waste.organic,
                  inorganic: transaction.storeWaste!.waste.inorganic + existingRow.waste.inorganic,
                ),
              );
            }

            if (transaction.withdrawnBalance != null) {
              existingRow = existingRow.copyWith(
                withdrawBalance: transaction.withdrawnBalance!.withdrawn + existingRow.withdrawBalance,
              );
            }

            rowsReport[existingIndex] = existingRow;
          } else {
            Waste rowWaste = transaction.storeWaste?.waste ?? const Waste(organic: 0, inorganic: 0);
            int rowWithdrawBalance = transaction.withdrawnBalance?.withdrawn ?? 0;
            rowsReport.add(RowReport(
              rt: transaction.user.rt,
              rw: transaction.user.rw,
              waste: rowWaste,
              withdrawBalance: rowWithdrawBalance,
            ));
          }
        }

        int totalWasteStored = totalOrganic + totalInorganic;

        TotalRowReport totalRowReport = TotalRowReport(
          waste: Waste(organic: totalOrganic, inorganic: totalInorganic),
          withdrawBalance: withdrawBalance,
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
          village: 'Ini Desa',
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
          totalWithdrawBalance: AppHelper.formatToThousandsInt(withdrawBalance),
        ));
      },
    );
  }
}
