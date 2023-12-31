part of 'create_user_form_bloc.dart';

@freezed
class CreateUserFormEvent with _$CreateUserFormEvent {
  const factory CreateUserFormEvent.imagePickerOpened() = _ImagePickerOpened;
  const factory CreateUserFormEvent.phoneNumberChanged(String phoneNumber) = _PhoneNumberChanged;
  const factory CreateUserFormEvent.fullNameChanged(String fullName) = _FullNameChanged;
  const factory CreateUserFormEvent.roleChanged(String role) = _RoleChanged;
  const factory CreateUserFormEvent.passwordChanged(String password) = _PasswordChanged;
  const factory CreateUserFormEvent.rtChanged(String rt) = _RtChanged;
  const factory CreateUserFormEvent.rwChanged(String rw) = _RwChanged;
  const factory CreateUserFormEvent.villageChanged(String village) = _VillageChanged;
  const factory CreateUserFormEvent.submitButtonPressed() = _SubmitButtonPressed;
}
