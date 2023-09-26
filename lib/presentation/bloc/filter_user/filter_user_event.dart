part of 'filter_user_bloc.dart';

@freezed
class FilterUserEvent with _$FilterUserEvent {
  const factory FilterUserEvent.loaded() = _Loaded;
  const factory FilterUserEvent.apply(FilterUser filter) = _Apply;
  const factory FilterUserEvent.reset() = _Reset;
}
