import 'package:bank_sampah/core/utils/exception.dart';
import 'package:bank_sampah/core/utils/firebase_extensions.dart';
import 'package:bank_sampah/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/waste_price_model.dart';

abstract class WastePriceRemoteDataSource {
  /// Saat admin melakukan update "harga limbah atau waste price"
  /// maka admin akan membuat waste price baru
  /// tidak bisa update waste price hanya bisa create new
  Future<void> createWastePrice(WastePriceModel wastePrice);

  /// Mengambil data waste price yang terbaru saja
  Future<WastePriceModel> getCurrentWastePrice();

  /// Mengambil semua data waste price untuk history/sejarah
  Future<List<WastePriceModel>> getWastePrices();
}

class WastePriceRemoteDataSourceImpl implements WastePriceRemoteDataSource {
  final FirebaseFirestore _firestore;

  const WastePriceRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createWastePrice(WastePriceModel wastePriceModel) async {
    try {
      await _firestore.wastePriceColRef.add(wastePriceModel.toJson());
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<WastePriceModel> getCurrentWastePrice() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('waste_prices').orderBy('create_at', descending: true).limit(1).get();
      final List<WastePriceModel> wastePrices =
          snapshot.docs.map((doc) => WastePriceModel.fromJson(doc.data())).toList();
      if (wastePrices.isNotEmpty) {
        return wastePrices.first;
      } else {
        return const WastePriceModel(
          id: 'defaut',
          organic: 2000,
          inorganic: 3000,
          createAt: 1691113133,
          admin: UserModel(
            id: 'default',
            phoneNumber: '899-9999-9999',
            password: '',
            fullName: 'Kaesa Lyrih',
            photoUrl: 'https://github.com/lyrihkaesa.png',
            role: 'admin',
          ),
        );
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<WastePriceModel>> getWastePrices() async {
    final wastePriceRef = _firestore.wastePriceColRef.withConverter<WastePriceModel>(
      fromFirestore: (snapshot, options) => WastePriceModel.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
    try {
      final querySnapshot = await wastePriceRef.orderBy('create_at', descending: true).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
