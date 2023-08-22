part of 'report_bloc.dart';

@freezed
class ReportEvent with _$ReportEvent {
  const factory ReportEvent.initial(TimeSpan timeSpan) = _Initial;
  const factory ReportEvent.chooseTimeRange(TimeSpan timeSpan) = _ChooseTimeRange;
}
