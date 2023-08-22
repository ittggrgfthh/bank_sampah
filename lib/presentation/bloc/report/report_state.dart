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
  }) = _ReportState;

  factory ReportState.initial() => ReportState(
        isLoading: false,
        failure: none(),
        report: none(),
        totalWithdrawBalance: '',
        totalWasteStored: '',
        totalOrganic: '',
        totalInorganic: '',
        totalOrganicBalance: '',
        totalInorganicBalance: '',
      );
}