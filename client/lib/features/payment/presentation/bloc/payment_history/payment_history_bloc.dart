import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/features/payment/domain/usecases/get_my_payment_usecase.dart';
import 'package:client/features/payment/presentation/bloc/payment_history/payment_history_event.dart';
import 'package:client/features/payment/presentation/bloc/payment_history/payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final GetMyPaymentUsecase useCase;

  PaymentHistoryBloc(this.useCase) : super(PaymentHistoryInitial()) {
    on<LoadPaymentHistory>((event, emit) async {
      emit(PaymentHistoryLoading());
      try {
        final payments = await useCase.execute();
        emit(PaymentHistoryLoaded(payments));
      } catch (e) {
        emit(PaymentHistoryError('Failed to load payment history'));
      }
    });
  }
}
