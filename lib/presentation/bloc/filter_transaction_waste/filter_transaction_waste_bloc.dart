import 'package:bank_sampah/domain/entities/filter_transaction_waste.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_transaction_waste_event.dart';
part 'filter_transaction_waste_state.dart';
part 'filter_transaction_waste_bloc.freezed.dart';

class FilterTransactionWasteBloc extends Bloc<FilterTransactionWasteEvent, FilterTransactionWasteState> {
  FilterTransactionWasteBloc() : super(_Initial()) {
    on<FilterTransactionWasteEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
