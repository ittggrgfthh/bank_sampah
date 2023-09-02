import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'data/datasources/datasources.dart';
import 'data/repositories/repositories.dart';
import 'domain/repositories/repositories.dart';
import 'domain/usecase/usecase.dart';
import 'presentation/bloc/bloc.dart';

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
  getIt.registerFactory(() => ReportBloc(getIt()));
  getIt.registerFactory(() => EditWastePriceBloc(getIt(), getIt()));
  getIt.registerFactory(() => EditWastePriceHistoryBloc(getIt()));

  getIt.registerFactory(() => UpdateUserFormBloc(getIt(), getIt(), getIt(), getIt()));
  // bloc - staff
  getIt.registerFactory(() => StoreWasteFormBloc(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => TransactionHistoryBloc(getIt()));
  getIt.registerFactory(() => EditStoreWasteFormBloc(getIt()));
  getIt.registerFactory(() => WithdrawBalanceFormBloc(getIt()));
  // bloc - warga
  getIt.registerFactory(() => WargaHomeBloc(getIt(), getIt()));

  // usecase
  getIt.registerLazySingleton(() => PickImage(getIt(), getIt()));
  getIt.registerLazySingleton(() => UploadProfilePicture(getIt()));

  getIt.registerLazySingleton(() => CreateUser(getIt()));
  getIt.registerLazySingleton(() => SigninWithPhoneNumberAndPassword(getIt()));
  getIt.registerLazySingleton(() => GetSignedInUser(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => GetUserById(getIt()));
  getIt.registerLazySingleton(() => GetUserByPhoneNumber(getIt()));
  getIt.registerLazySingleton(() => UpdateUser(getIt()));

  getIt.registerLazySingleton(() => GetAllUserByRole(getIt()));
  // usecase - harga limbah organik dan an-organik
  getIt.registerLazySingleton(() => CreateWastePrice(getIt()));
  getIt.registerLazySingleton(() => GetCurrentWastePrice(getIt()));
  getIt.registerLazySingleton(() => GetWastePrices(getIt()));
  // usecase - transaction
  getIt.registerLazySingleton(() => CreateWasteTransaction(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByStaffId(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByTimeSpan(getIt()));
  getIt.registerLazySingleton(() => UpdateWasteTransaction(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByUserId(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsFilter(getIt()));

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
