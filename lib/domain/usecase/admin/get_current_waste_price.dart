import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/waste_price.dart';
import '../../repositories/waste_price_repository.dart';

class GetCurrentWastePrice {
  const GetCurrentWastePrice(this._wastePriceRepository);
  final WastePriceRepository _wastePriceRepository;

  Future<Either<Failure, WastePrice>> call() {
    return _wastePriceRepository.getCurrentWastePrice();
  }
}
