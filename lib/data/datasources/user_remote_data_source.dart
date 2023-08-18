import 'dart:io';

import 'package:bank_sampah/core/utils/app_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

import '../../core/constant/firebase_storage_paths.dart';
import '../../core/utils/exception.dart';
import '../../core/utils/firebase_extensions.dart';
import '../models/point_balance_model.dart';
import '../models/user_model.dart';
import '../models/waste_model.dart';

/// Ini biasanya digunakan untuk mendapatkan data pengguna yang berasal dari internet,
/// Bisa dari Rest API atau Cloud Firestore
/// Silahkan modifikasi sesuai dengan kebutuhan apakah lewat Rest API atau Cloud Firestore.
abstract class UserRemoteDataSource {
  // Register - Membuat pengguna baru
  Future<UserModel> createUser(UserModel userModel);

  // Mendapatkan pengguna berdasarkan userId
  Future<UserModel> getUserById(String userId);

  // Mendapatkan semua pengguna
  Future<List<UserModel>> getAllUser();

  // Mengedit pengguna
  Future<UserModel> updateUser(UserModel userModel);

  // Menghapus pengguna
  Future<void> deleteUser(String userId);

  // Login - Mendapatkan pengguna berdasarkan nomor telepon dan kata sandi
  Future<UserModel> getUserByPhoneNumberAndPassword({
    required String phoneNumber,
    required String password,
  });

  // Mendapatkan semua pengguna berdasarkan role
  Future<List<UserModel>> getAllUserByRole(String role);

  // Mendapatkan semua pengguna berdasarkan role
  Future<UserModel> getUserByPhoneNumber(String phoneNumber);

  // Menunggah foto profil penggguna
  Future<String> uploadProfilePicture({
    required File picture,
    required String userId,
  });

  // Old method
  Stream<UserModel?> getUserProfile(String userId);
  Future<void> createUserProfile(UserModel userModel);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  const UserRemoteDataSourceImpl(this._firestore, this._firebaseStorage);

  @override
  Future<UserModel> createUser(UserModel userModel) async {
    final batch = _firestore.batch();
    final newUserModel = userModel.copyWith(id: 'user_${AppHelper.v4UUIDWithoutDashes()}');
    final userDocRef = _firestore.userDocRef(newUserModel.id);
    final pointBalanceDocRef = _firestore.pointBalanceDocRef(newUserModel.id);

    final newPointBalance = PointBalanceModel(
      userId: newUserModel.id,
      currentBalance: 0,
      waste: const WasteModel(
        organic: 0,
        inorganic: 0,
      ),
    );

    batch.set(userDocRef, newUserModel.copyWith(pointBalance: newPointBalance).toJson());
    batch.set(pointBalanceDocRef, newPointBalance.toJson());

    try {
      final querySnapshot =
          await _firestore.userColRef.where('phone_number', isEqualTo: newUserModel.phoneNumber).get();
      if (querySnapshot.docs.isNotEmpty) {
        throw ServerException();
      }
      await batch.commit();
      return await getUserById(newUserModel.id);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserByPhoneNumberAndPassword({required String phoneNumber, required String password}) async {
    final userRef = _firestore.userColRef.withConverter<UserModel>(
      fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot = await userRef
          .where(
            'phone_number',
            isEqualTo: phoneNumber,
          )
          .where(
            'password',
            isEqualTo: password,
          )
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw AuthException('Nomor telepon tidak ditemukan!');
      }
      return querySnapshot.docs.first.data();
    } catch (e) {
      if (e is AuthException) {
        throw AuthException(e.toString());
      }
      throw ServerException();
    }
  }

  @override
  Stream<UserModel?> getUserProfile(String userId) async* {
    yield* _firestore.userDocRef(userId).snapshots().map((doc) {
      if (!doc.exists) {
        // Firestore is unreachable
        if (doc.metadata.isFromCache) {
          throw FirebaseException(
            plugin: 'Firestore',
            code: 'UNAVAILABLE',
          );
        }

        // No user profile yet
        return null;
      }

      return UserModel.fromFirestore(
        doc,
      );
    });
  }

  @override
  Future<void> createUserProfile(UserModel userModel) async {
    final batch = _firestore.batch();
    final userDocRef = _firestore.userDocRef(userModel.id);
    final pointBalanceDocRef = _firestore.pointBalanceDocRef(userModel.id);

    batch.set(userDocRef, userModel.toJson());
    batch.set(pointBalanceDocRef, userModel.toJson());

    await batch.commit();
  }

  @override
  Future<String> uploadProfilePicture({required File picture, required String userId}) async {
    final path = '${FirebaseStoragePaths.profilePicture}/$userId${p.extension(picture.path)}';
    await _firebaseStorage.ref(path).putFile(picture);
    return path;
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.userColRef.doc(userId).delete();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    final userRef = _firestore.userColRef.withConverter<UserModel>(
      fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot = await userRef.orderBy('created_at', descending: true).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getAllUserByRole(String role) async {
    final userRef = _firestore.userColRef.withConverter<UserModel>(
      fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot = await userRef.where('role', isEqualTo: role).orderBy('updated_at', descending: true).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final doc = await _firestore.userColRef.doc(userId).get();
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> updateUser(UserModel userModel) async {
    final batch = _firestore.batch();
    final userDocRef = _firestore.userDocRef(userModel.id);
    final pointBalanceDocRef = _firestore.pointBalanceDocRef(userModel.id);
    try {
      batch.set(userDocRef, userModel.toJson());
      batch.set(pointBalanceDocRef, userModel.toJson());
      await batch.commit();
      return await getUserById(userModel.id);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserByPhoneNumber(String phoneNumber) async {
    final userRef = _firestore.userColRef.withConverter<UserModel>(
      fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot = await userRef.where('phone_number', isEqualTo: phoneNumber).get();
      if (querySnapshot.docs.isEmpty) {
        throw ServerException();
      }
      return querySnapshot.docs.first.data();
    } catch (e) {
      throw ServerException();
    }
  }
}
