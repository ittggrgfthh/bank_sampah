part of 'warga_home_bloc.dart';

@freezed
class WargaHomeEvent with _$WargaHomeEvent {
  const factory WargaHomeEvent.initialized(String userId) = _Initialized;
}
