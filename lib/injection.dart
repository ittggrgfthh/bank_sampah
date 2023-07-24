import 'package:bank_sampah/domain/usecase/create_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecase/create_user_profile.dart';
import 'domain/usecase/get_user_profile.dart';
import 'domain/usecase/pick_image.dart';
import 'domain/usecase/upload_profile_picture.dart';
import 'presentation/bloc/profile_setup_form_bloc/profile_setup_bloc.dart';

final getIt = GetIt.instance;

void init() {
  // bloc
  getIt.registerFactory(() => ProfileSetupFormBloc(getIt(), getIt(), getIt()));

  // usecase
  getIt.registerLazySingleton(() => GetUserProfile(getIt()));
  getIt.registerLazySingleton(() => CreateUserProfile(getIt()));
  getIt.registerLazySingleton(() => PickImage(getIt(), getIt()));
  getIt.registerLazySingleton(() => UploadProfilePicture(getIt()));

  getIt.registerLazySingleton(() => CreateUser(getIt()));

  // repository
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));

  // data source
  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(getIt(), getIt()));

// external
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);
  getIt.registerLazySingleton(() => ImagePicker());
  getIt.registerLazySingleton(() => ImageCropper());
  getIt.registerLazySingleton(() => NumberFormat.currency(
        locale: 'id_ID',
        decimalDigits: 0,
        symbol: 'Rp',
      ));
}
