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
  // bloc - app
  getIt.registerFactory(() => SignInFormBloc(getIt()));
  getIt.registerLazySingleton(() => AuthBloc(
        getSignedInUser: getIt(),
        signOut: getIt(),
        getUserById: getIt(),
      ));
  // bloc - filter
  getIt.registerLazySingleton(() => FilterUserBloc(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => FilterTransactionWasteBloc(getIt(), getIt()));

  // bloc - admin
  getIt.registerFactory(() => ReportBloc(getIt()));
  getIt.registerFactory(() => ListUserBloc(getIt()));
  getIt.registerFactory(() => CreateUserFormBloc(getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory(() => UpdateUserFormBloc(getIt(), getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory(() => EditWastePriceBloc(getIt(), getIt()));
  getIt.registerFactory(() => EditWastePriceHistoryBloc(getIt()));

  // bloc - staff
  getIt.registerFactory(() => StoreWasteFormBloc(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => TransactionHistoryBloc(getIt()));
  getIt.registerFactory(() => EditStoreWasteFormBloc(getIt()));
  getIt.registerFactory(() => WithdrawBalanceFormBloc(getIt(), getIt()));

  // bloc - warga
  getIt.registerFactory(() => WargaHomeBloc(getIt(), getIt()));

  // ==============
  // usecase - atuh
  getIt.registerLazySingleton(() => SigninWithPhoneNumberAndPassword(getIt()));
  getIt.registerLazySingleton(() => GetSignedInUser(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));

  getIt.registerLazySingleton(() => PickImage(getIt(), getIt()));
  getIt.registerLazySingleton(() => UploadProfilePicture(getIt()));

  // usecase - user
  getIt.registerLazySingleton(() => CreateUser(getIt()));
  getIt.registerLazySingleton(() => GetUserById(getIt()));
  getIt.registerLazySingleton(() => GetUserByPhoneNumber(getIt()));
  getIt.registerLazySingleton(() => UpdateUser(getIt()));
  getIt.registerLazySingleton(() => GetFilteredUsers(getIt()));
  // usecase - filter
  getIt.registerLazySingleton(() => GetUserFilter(getIt()));
  getIt.registerLazySingleton(() => SaveUserFilter(getIt()));
  getIt.registerLazySingleton(() => ResetDefaultUserFilter(getIt()));

  // usecase - harga limbah organik dan an-organik
  getIt.registerLazySingleton(() => GetCurrentWastePrice(getIt()));
  getIt.registerLazySingleton(() => CreateWastePrice(getIt()));
  getIt.registerLazySingleton(() => GetWastePrices(getIt()));
  // usecase - transaction
  getIt.registerLazySingleton(() => CreateWasteTransaction(getIt()));
  getIt.registerLazySingleton(() => UpdateWasteTransaction(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByStaffId(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByTimeSpan(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsByUserId(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsFilter(getIt()));
  // usecase - filter
  getIt.registerLazySingleton(() => GetTransactionWasteFilter(getIt()));
  getIt.registerLazySingleton(() => SaveTransactionWasteFilter(getIt()));

  // ==============
  // repository - user
  getIt.registerLazySingleton<AuthFacade>(() => AuthFacadeImpl(getIt(), getIt()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt(), getIt()));
  // repository - waste
  getIt.registerLazySingleton<WastePriceRepository>(() => WastePriceRepositoryImpl(getIt()));
  getIt.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(getIt(), getIt()));

  // ==============
  // datasource - user
  getIt.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());
  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(getIt(), getIt()));
  // datasource - waste
  getIt.registerLazySingleton<WastePriceRemoteDataSource>(() => WastePriceRemoteDataSourceImpl(getIt()));
  // datasource - transaction
  getIt.registerLazySingleton<TransactionLocalDataSource>(() => TransactionLocalDataSourceImpl());
  getIt.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionRemoteDataSourceImpl(getIt()));

  // ==============
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
