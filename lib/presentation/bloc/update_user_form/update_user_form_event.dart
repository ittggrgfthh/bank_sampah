part of 'update_user_form_bloc.dart';

@freezed
class UpdateUserFormEvent with _$UpdateUserFormEvent {
  const factory UpdateUserFormEvent.initial(User user) = _Initial;
  const factory UpdateUserFormEvent.imagePickerOpened() = _ImagePickerOpened;
  const factory UpdateUserFormEvent.phoneNumberChanged(String phoneNumber) = _PhoneNumberChanged;
  const factory UpdateUserFormEvent.fullNameChanged(String fullName) = _FullNameChanged;
  const factory UpdateUserFormEvent.roleChanged(String role) = _RoleChanged;
  const factory UpdateUserFormEvent.passwordChanged(String password) = _PasswordChanged;
  const factory UpdateUserFormEvent.rtChanged(String rt) = _RtChanged;
  const factory UpdateUserFormEvent.rwChanged(String rw) = _RwChanged;
  const factory UpdateUserFormEvent.villageChanged(String village) = _VillageChanged;
  const factory UpdateUserFormEvent.submitButtonPressed() = _SubmitButtonPressed;
}
