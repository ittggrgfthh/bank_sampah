part of 'filter_user_bloc.dart';

@freezed
class FilterUserEvent with _$FilterUserEvent {
  const factory FilterUserEvent.filterLoaded() = _FilterLoaded;
  const factory FilterUserEvent.filterSaved(FilterUser filter) = _FilterSaved;
  const factory FilterUserEvent.filterCleared() = _FilterCleared;
}
