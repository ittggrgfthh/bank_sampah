import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constant/firebase_exception_codes.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/waste_price.dart';
import '../../domain/repositories/waste_price_repository.dart';
import '../datasources/waste_price_remote_data_source.dart';
import '../models/waste_price_model.dart';

class WastePriceRepositoryImpl implements WastePriceRepository {
  final WastePriceRemoteDataSource _wastePriceRemoteDataSource;

  WastePriceRepositoryImpl(this._wastePriceRemoteDataSource);

  @override
  Future<Either<Failure, Unit>> createWastePrice(WastePrice wastePrice) async {
    try {
      await _wastePriceRemoteDataSource.createWastePrice(WastePriceModel.formDomain(wastePrice));
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WastePrice>> getCurrentWastePrice() async {
    try {
      final wastePriceModel = await _wastePriceRemoteDataSource.getCurrentWastePrice();
      return right(wastePriceModel.toDomain());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WastePrice>>> getWastePrices() async {
    try {
      final listWastePriceModel = await _wastePriceRemoteDataSource.getWastePrices();
      return right(listWastePriceModel.map((wastePriceModel) => wastePriceModel.toDomain()).toList());
    } on FirebaseException catch (e) {
      if (e.code == FirebaseExceptionCodes.unavailable) {
        return left(const Failure.timeout());
      }
      return left(Failure.unexpected(e.toString()));
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }
}
