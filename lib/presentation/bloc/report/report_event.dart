part of 'report_bloc.dart';

@freezed
class ReportEvent with _$ReportEvent {
  const factory ReportEvent.chooseTimeRange(TimeSpan timeSpan) = _ChooseTimeRange;
  const factory ReportEvent.chooseVillage(String village) = _ChooseVillage;
}
