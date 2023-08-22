import 'dart:collection';

import 'package:bank_sampah/domain/entities/transaction_waste.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/failures/failure.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/usecase/staff/get_transaction_by_time_span.dart';

part 'report_event.dart';
part 'report_state.dart';
part 'report_bloc.freezed.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetTransactionsByTimeSpan _getTransactionsByTimeSpan;
  ReportBloc(this._getTransactionsByTimeSpan) : super(ReportState.initial()) {
    on<ReportEvent>((event, emit) async {
      await event.when(
        initial: (timeSpan) => _handleInitial(emit, timeSpan),
        chooseTimeRange: (timeSpan) => _handleChooseTimeRange(emit, timeSpan),
      );
    });
  }

  Future<void> _handleInitial(Emitter<ReportState> emit, TimeSpan timeSpan) async {
    emit(state.copyWith(isLoading: true));

    final failureOrSuccess = await _getTransactionsByTimeSpan(timeSpan);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: optionOf(failure),
      )),
      (transactions) {
        Map<String, List<TransactionWaste>> rtRwMap = {};

        for (var transactionWaste in transactions) {
          String rtRw = "${transactionWaste.user.rw}-${transactionWaste.user.rt}";
          if (!rtRwMap.containsKey(rtRw)) {
            rtRwMap[rtRw] = [];
          }
          rtRwMap[rtRw]!.add(transactionWaste);
        }
        // Sorting the groups based on rw
        var sortedGroups = rtRwMap.keys.toList()..sort();

        // Creating a new map with sorted groups
        var sortedRtRwMap = <String, List<TransactionWaste>>{};
        for (var groupKey in sortedGroups) {
          sortedRtRwMap[groupKey] = rtRwMap[groupKey]!;
        }

        // Now sortedRtRwMap contains the transactions grouped and sorted by rw and rt
        print(sortedRtRwMap);

        // RowReport(rt: rt, rw: rw, waste: waste, withdrawBalance: withdrawBalance);
        // Report report = Report(
        //   createdAt: DateTime.now().millisecondsSinceEpoch,
        //   createdAtCity: 'Semarang',
        //   village: 'Ini Desa',
        //   rowsReport: [],
        //   total: TotalRowReport(waste: waste, withdrawBalance: withdrawBalance, sumWaste: sumWaste,),
        //   timeSpan: timeSpan,
        // )
        emit(state.copyWith(
          isLoading: false,
          failure: none(),
        ));
      },
    );
  }

  Future<void> _handleChooseTimeRange(Emitter<ReportState> emit, TimeSpan timeSpan) async {}
}
