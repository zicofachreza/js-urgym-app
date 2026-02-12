import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:client/features/payment/domain/usecases/create_payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentUseCase useCase;

  PaymentBloc(this.useCase) : super(PaymentInitial()) {
    on<CreatePayment>((event, emit) async {
      emit(PaymentLoading());
      try {
        final result = await useCase.execute(event.planId);

        emit(
          PaymentSuccess(
            snapToken: result['snap_token'],
            redirectUrl: result['redirect_url'],
          ),
        );
      } on DioException catch (e) {
        final msg = e.response?.data['message'];
        emit(PaymentError(msg));
      } catch (e) {
        emit(PaymentError('Failed to create payment'));
      }
    });
  }
}
