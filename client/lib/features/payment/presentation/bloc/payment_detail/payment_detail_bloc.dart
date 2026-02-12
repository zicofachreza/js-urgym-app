import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:client/features/payment/domain/usecases/get_my_payment_by_id_usecase.dart';
import 'package:client/features/payment/domain/usecases/cancel_payment_usecase.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_event.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDetailBloc extends Bloc<PaymentDetailEvent, PaymentDetailState> {
  final GetMyPaymentByIdUsecase getPaymentUsecase;
  final CancelPaymentUsecase cancelPaymentUsecase;

  PaymentModel? _payment;

  PaymentDetailBloc(this.getPaymentUsecase, this.cancelPaymentUsecase)
    : super(PaymentDetailLoading()) {
    on<LoadPaymentDetail>(_onLoadPaymentDetail);
    on<OpenPayment>(_onOpenPayment);
    on<CancelAndReloadPayment>(_onCancelAndReloadPayment);
  }

  Future<void> _onLoadPaymentDetail(
    LoadPaymentDetail event,
    Emitter<PaymentDetailState> emit,
  ) async {
    emit(PaymentDetailLoading());

    try {
      final payment = await getPaymentUsecase.execute(event.paymentId);
      _payment = payment;
      emit(PaymentDetailLoaded(payment));
    } catch (e) {
      emit(PaymentDetailError('Failed to load payment detail'));
    }
  }

  void _onOpenPayment(OpenPayment event, Emitter<PaymentDetailState> emit) {
    if (_payment == null ||
        _payment!.snapUrl == null ||
        _payment!.snapUrl!.isEmpty) {
      emit(PaymentDetailError('Payment URL not available'));
      return;
    }

    emit(PaymentDetailOpenPayment(_payment!.snapUrl!));

    emit(PaymentDetailLoaded(_payment!));
  }

  Future<void> _onCancelAndReloadPayment(
    CancelAndReloadPayment event,
    Emitter<PaymentDetailState> emit,
  ) async {
    emit(PaymentDetailLoading());

    try {
      final msg = await cancelPaymentUsecase.execute(event.paymentId);
      emit(PaymentDetailCancelSuccess(msg));

      final payment = await getPaymentUsecase.execute(event.paymentId);
      _payment = payment;
      emit(PaymentDetailLoaded(payment));
    } catch (e) {
      emit(PaymentDetailError('Failed to cancel payment'));
    }
  }
}
