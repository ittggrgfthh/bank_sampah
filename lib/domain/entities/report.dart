import 'package:freezed_annotation/freezed_annotation.dart';

import 'waste.dart';

part 'report.freezed.dart';

@freezed
class Report with _$Report {
  const factory Report({
    required int createdAt,
    required String createdAtCity,
    required String village,
    required TimeSpan timeSpan,
    required List<RowReport> rowsReport,
    required TotalRowReport total,
  }) = _Report;

  const Report._();
}

@freezed
class TimeSpan with _$TimeSpan {
  const factory TimeSpan({
    required int start, // >= 01 Agustus 2023 00:00:00
    required int end, // < 01 Agustus 2023 00:00:00
  }) = _TimeSpan;

  const TimeSpan._();
}

@freezed
class RowReport with _$RowReport {
  const factory RowReport({
    required String rt,
    required String rw,
    required Waste waste,
    required int withdrawBalance,
  }) = _RowReport;

  const RowReport._();
}

@freezed
class TotalRowReport with _$TotalRowReport {
  const factory TotalRowReport({
    required Waste waste,
    required int withdrawBalance,
    required int sumWaste,
  }) = _TotalRowReport;

  const TotalRowReport._();
}
