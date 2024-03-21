import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constant/firebase_storage_paths.dart';
import '../../core/utils/exception.dart';
import '../../core/utils/hash.dart';
import '../models/filter_user_model.dart';
import '../models/user_model.dart';

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

  // Mendapatkan semua pengguna berdasarkan role
  Future<List<UserModel>> getAllUserByRole(String role);

  // Mendapatkan semua pengguna berdasarkan phoneNumber
  Future<UserModel> getUserByPhoneNumber(String phoneNumber);

  // Menunggah foto profil penggguna
  Future<String> uploadProfilePicture({
    required File picture,
    required String userId,
  });

  /// Mendapatkan semua pengguna sesuai dengan filter
  Future<List<UserModel>> getFilteredUsers(FilterUserModel filter);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final FirebaseStorage _firebaseStorage;

  const UserRemoteDataSourceImpl(this._supabaseClient, this._firebaseStorage);

  @override
  Future<UserModel> createUser(UserModel userModel) async {
    final hashPassword = HashFacade().make(userModel.password);
    final newUserModel = userModel.copyWith(
      password: hashPassword,
      role: userModel.role.toUpperCase(),
    );
    try {
      final user = await _supabaseClient.from('users').insert(newUserModel.toJson()).select().single();
      return UserModel.fromJson(user);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserByPhoneNumber(String phoneNumber) async {
    try {
      final user = await _supabaseClient.from('users').select().eq('phone_number', phoneNumber).single();
      if (user.isEmpty) {
        throw MyAuthException('Nomor telepon tidak ditemukan!');
      }
      return UserModel.fromJson(user);
    } catch (e) {
      if (e is MyAuthException) {
        throw MyAuthException(e.toString());
      }
      throw ServerException();
    }
  }

  @override
  Future<String> uploadProfilePicture({required File picture, required String userId}) async {
    final path = '${FirebaseStoragePaths.profilePicture}/$userId${p.extension(picture.path)}';

    final uploadTask = await _firebaseStorage.ref(path).putFile(picture);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl.toString();
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _supabaseClient.from('users').delete().eq('id', userId);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    try {
      final users = await _supabaseClient.from('users').select();
      return users.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getAllUserByRole(String role) async {
    try {
      final users = await _supabaseClient.from('users').select().eq('role', role.toUpperCase());
      return users.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final user = await _supabaseClient.from('users').select().eq('id', userId).single();
      return UserModel.fromJson(user);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> updateUser(UserModel userModel) async {
    try {
      final user =
          await _supabaseClient.from('users').update(userModel.toJson()).eq('id', userModel.id).select().single();
      return UserModel.fromJson(user);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getFilteredUsers(FilterUserModel filter) async {
    try {
      var query = _supabaseClient.from('users').select();
      // Filter berdasarkan userId jika tersedia
      if (filter.userId != null) {
        query = query.eq('id', filter.userId!);
      }

      // Filter berdasarkan fullName jika tersedia
      if (filter.fullName != null) {
        query = query.eq('full_name', filter.fullName!);
      }

      // Filter berdasarkan roles jika tersedia
      if (filter.role != null) {
        query = query.eq('role', filter.role!.toUpperCase());
      }

      // Filter berdasarkan villages jika tersedia
      if (filter.villages != null && filter.villages!.isNotEmpty) {
        query = query.inFilter('village', filter.villages!);
      }

      if (filter.rts != null && filter.rts!.isNotEmpty) {
        query = query.inFilter('rt', filter.rts!);
      }

      if (filter.rws != null && filter.rws!.isNotEmpty) {
        query = query.inFilter('rw', filter.rws!);
      }

      final users = await query;
      return users.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
