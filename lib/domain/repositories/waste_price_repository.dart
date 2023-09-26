import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../entities/waste_price.dart';

abstract class WastePriceRepository {
  Future<Either<Failure, Unit>> createWastePrice(WastePrice wastePrice);
  Future<Either<Failure, WastePrice>> getCurrentWastePrice();
  Future<Either<Failure, List<WastePrice>>> getWastePrices();
}
