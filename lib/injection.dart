import 'package:bank_sampah/data/datasources/transaction_remote_data_source.dart';
import 'package:bank_sampah/data/repositories/transaction_repository_impl.dart';
import 'package:bank_sampah/domain/repositories/transaction_repository.dart';
import 'package:bank_sampah/domain/usecase/staff/get_transactions_by_staff_id.dart';
import 'package:bank_sampah/presentation/bloc/store_waste_form/store_waste_form_bloc.dart';
import 'package:bank_sampah/presentation/bloc/transaction_history/transaction_history_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'data/datasources/user_local_data_source.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/datasources/waste_price_remote_data_source.dart';
import 'data/repositories/auth_facade_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/waste_price_repository_impl.dart';
import 'domain/repositories/auth_facade.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/waste_price_repository.dart';
import 'domain/usecase/admin/create_waste_price.dart';
import 'domain/usecase/admin/get_all_user_by_role.dart';
import 'domain/usecase/admin/get_current_waste_price.dart';
import 'domain/usecase/admin/get_waste_prices.dart';
import 'domain/usecase/create_user.dart';
import 'domain/usecase/create_user_profile.dart';
import 'domain/usecase/get_signed_in_user.dart';
import 'domain/usecase/get_user_by_id.dart';
import 'domain/usecase/get_user_by_phone_number.dart';
import 'domain/usecase/get_user_profile.dart';
import 'domain/usecase/pick_image.dart';
import 'domain/usecase/sign_out.dart';
import 'domain/usecase/signin_with_phone_number_and_password.dart';
import 'domain/usecase/staff/create_waste_transaction.dart';
import 'domain/usecase/upload_profile_picture.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/bloc/create_user_form/create_user_form_bloc.dart';
import 'presentation/bloc/edit_waste_price/edit_waste_price_bloc.dart';
import 'presentation/bloc/list_user/list_user_bloc.dart';
import 'presentation/bloc/signin_form_bloc/signin_form_bloc.dart';

final getIt = GetIt.instance;

void init() {
  // bloc
  getIt.registerFactory(() => CreateUserFormBloc(getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ListUserBloc(getIt()));
  getIt.registerFactory(() => SignInFormBloc(getIt()));
  getIt.registerLazySingleton(() => AuthBloc(
        getSignedInUser: getIt(),
        signOut: getIt(),
        getUserById: getIt(),
      ));

  // bloc - admin
  getIt.registerFactory(() => EditWastePriceBloc(getIt(), getIt()));
  // bloc - staff
  getIt.registerFactory(() => StoreWasteFormBloc(getIt(), getIt()));
  getIt.registerFactory(() => TransactionHistoryBloc(getIt()));

  // usecase
  getIt.registerLazySingleton(() => GetUserProfile(getIt()));
  getIt.registerLazySingleton(() => CreateUserProfile(getIt()));
  getIt.registerLazySingleton(() => PickImage(getIt(), getIt()));
  getIt.registerLazySingleton(() => UploadProfilePicture(getIt()));

  getIt.registerLazySingleton(() => CreateUser(getIt()));
  getIt.registerLazySingleton(() => SigninWithPhoneNumberAndPassword(getIt()));
  getIt.registerLazySingleton(() => GetSignedInUser(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => GetUserById(getIt()));
  getIt.registerLazySingleton(() => GetUserByPhoneNumber(getIt()));

  getIt.registerLazySingleton(() => GetAllUserByRole(getIt()));
  // usecase - harga limbah organik dan an-organik
  getIt.registerLazySingleton(() => CreateWastePrice(getIt()));
  getIt.registerLazySingleton(() => GetCurrentWastePrice(getIt()));
  getIt.registerLazySingleton(() => GetWastePrices(getIt()));
  // usecase - transaction
  getIt.registerLazySingleton(() => CreateWasteTransaction(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByStaffId(getIt()));

  // repository
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));
  getIt.registerLazySingleton<AuthFacade>(() => AuthFacadeImpl(getIt(), getIt()));
  // repository - waste
  getIt.registerLazySingleton<WastePriceRepository>(() => WastePriceRepositoryImpl(getIt()));
  getIt.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(getIt()));

  // datasource
  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(getIt(), getIt()));
  getIt.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());
  // datasource - waste
  getIt.registerLazySingleton<WastePriceRemoteDataSource>(() => WastePriceRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionRemoteDataSourceImpl(getIt()));

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
