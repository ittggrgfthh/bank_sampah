part of 'report_bloc.dart';

@freezed
class ReportState with _$ReportState {
  const factory ReportState({
    required bool isLoading,
    required Option<Failure> failure,
    required Option<Report> report,
    required String totalWithdrawBalance,
    required String totalWasteStored,
    required String totalOrganic,
    required String totalInorganic,
    required String totalOrganicBalance,
    required String totalInorganicBalance,
    required TimeSpan timeSpan,
    required String village,
  }) = _ReportState;

  factory ReportState.initial() => ReportState(
        isLoading: false,
        failure: none(),
        report: none(),
        totalWithdrawBalance: '0',
        totalWasteStored: '0',
        totalOrganic: '0',
        totalInorganic: '0',
        totalOrganicBalance: '0',
        totalInorganicBalance: '0',
        timeSpan: const TimeSpan(start: 0, end: 999999999999999),
        village: 'Banyubiru',
      );
}
