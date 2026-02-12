import 'package:client/core/network/dio_client.dart';
import 'package:client/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:client/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:client/features/payment/domain/usecases/cancel_payment_usecase.dart';
import 'package:client/features/payment/domain/usecases/get_my_payment_by_id_usecase.dart';
import 'package:client/features/payment/presentation/bloc/payment_cancel/payment_cancel_bloc.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_bloc.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_event.dart';
import 'package:client/features/payment/presentation/pages/payment_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/features/payment/presentation/bloc/payment_history/payment_history_bloc.dart';
import 'package:client/features/payment/presentation/bloc/payment_history/payment_history_event.dart';
import 'package:client/features/payment/presentation/bloc/payment_history/payment_history_state.dart';
import 'package:client/features/payment/presentation/widgets/payment_card.dart';
import 'package:client/features/payment/presentation/widgets/payment_empty_state.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentHistoryBloc>().add(LoadPaymentHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
        builder: (context, state) {
          if (state is PaymentHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
              ),
            );
          }

          if (state is PaymentHistoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color.fromARGB(255, 172, 14, 3)),
              ),
            );
          }

          if (state is PaymentHistoryLoaded) {
            if (state.payments.isEmpty) {
              return const PaymentEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final payment = state.payments[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          final dio = DioClient.create();

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) {
                                  final repository = PaymentRepositoryImpl(
                                    PaymentRemoteDatasource(dio),
                                  );

                                  return PaymentDetailBloc(
                                    GetMyPaymentByIdUsecase(repository),
                                    CancelPaymentUsecase(repository),
                                  )..add(LoadPaymentDetail(payment.id));
                                },
                              ),
                              BlocProvider(
                                create: (_) => PaymentCancelBloc(
                                  CancelPaymentUsecase(
                                    PaymentRepositoryImpl(
                                      PaymentRemoteDatasource(dio),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            child: PaymentDetailPage(paymentId: payment.id),
                          );
                        },
                      ),
                    );

                    if (!context.mounted) return;

                    context.read<PaymentHistoryBloc>().add(
                      LoadPaymentHistory(),
                    );
                  },
                  child: PaymentCard(payment: payment),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
