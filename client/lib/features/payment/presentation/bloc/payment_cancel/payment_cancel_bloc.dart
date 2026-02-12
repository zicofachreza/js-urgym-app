import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:client/features/payment/domain/usecases/cancel_payment_usecase.dart';
import 'package:client/features/payment/presentation/bloc/payment_cancel/payment_cancel_event.dart';
import 'package:client/features/payment/presentation/bloc/payment_cancel/payment_cancel_state.dart';

class PaymentCancelBloc extends Bloc<PaymentCancelEvent, PaymentCancelState> {
  final CancelPaymentUsecase useCase;

  PaymentCancelBloc(this.useCase) : super(PaymentCancelInitial()) {
    on<SubmitCancelPayment>((event, emit) async {
      emit(PaymentCancelLoading());
      try {
        final msg = await useCase.execute(event.paymentId);
        emit(PaymentCancelSuccess(msg));
      } on DioException catch (e) {
        final msg = e.response?.data['message'];
        emit(PaymentCancelError(msg));
      } catch (e) {
        emit(PaymentCancelError('Failed to cancel payment'));
      }
    });
  }
}
