import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/waste_price.dart';
import '../../repositories/waste_price_repository.dart';

class CreateWastePrice {
  const CreateWastePrice(this._wastePriceRepository);

  final WastePriceRepository _wastePriceRepository;

  Future<Either<Failure, Unit>> call(WastePrice wastePrice) {
    return _wastePriceRepository.createWastePrice(wastePrice);
  }
}
