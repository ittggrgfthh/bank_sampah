import 'package:bank_sampah/core/utils/exception.dart';
import 'package:bank_sampah/core/utils/firebase_extensions.dart';
import 'package:bank_sampah/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/point_balance_model.dart';
import '../models/waste_model.dart';
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
    const uuid = Uuid();
    final v4 = uuid.v4();
    final v4WithoutDashes = v4.replaceAll('-', '');
    final newWastePriceModel = wastePriceModel.copyWith(id: 'wastePrice_$v4WithoutDashes');
    try {
      await _firestore.wastePriceDocRef(newWastePriceModel.id).set(newWastePriceModel.toJson());
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<WastePriceModel> getCurrentWastePrice() async {
    try {
      final snapshot = await _firestore.wastePriceColRef.orderBy('created_at', descending: true).limit(1).get();
      final wastePrices = snapshot.docs.map((doc) => WastePriceModel.fromJson(doc.data())).toList();
      if (wastePrices.isNotEmpty) {
        return wastePrices.first;
      } else {
        final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;
        return WastePriceModel(
          id: 'defaut',
          organic: 9999999,
          inorganic: 9999999,
          createdAt: dateNowEpoch - 9000,
          admin: UserModel(
            id: 'default',
            phoneNumber: '899-9999-9999',
            password: '',
            fullName: 'Kaesa Lyrih {Default Error}',
            photoUrl: 'unkown',
            role: 'admin',
            pointBalance: const PointBalanceModel(
              userId: 'default',
              currentBalance: 0,
              waste: WasteModel(
                inorganic: 0,
                organic: 0,
              ),
            ),
            createdAt: dateNowEpoch,
            updatedAt: dateNowEpoch,
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
