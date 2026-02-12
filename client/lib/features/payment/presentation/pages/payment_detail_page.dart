import 'package:client/features/payment/presentation/pages/payment_webview_page.dart';
import 'package:client/features/payment/presentation/widgets/danger_button.dart';
import 'package:client/features/payment/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_bloc.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_state.dart';
import 'package:client/features/payment/presentation/bloc/payment_detail/payment_detail_event.dart';
import 'package:client/features/payment/presentation/widgets/payment_detail_card.dart';

class PaymentDetailPage extends StatelessWidget {
  final String paymentId;
  const PaymentDetailPage({super.key, required this.paymentId});

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
      ),
      body: BlocListener<PaymentDetailBloc, PaymentDetailState>(
        listener: (context, state) {
          if (state is PaymentDetailOpenPayment) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PaymentWebViewPage(url: state.snapUrl),
              ),
            );
          }

          if (state is PaymentDetailCancelSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color.fromARGB(255, 4, 80, 20),
              ),
            );
          }

          if (state is PaymentDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Color.fromARGB(255, 33, 33, 33),
              ),
            );
          }
        },
        child: BlocBuilder<PaymentDetailBloc, PaymentDetailState>(
          builder: (context, state) {
            if (state is PaymentDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 172, 14, 3),
                ),
              );
            }

            if (state is PaymentDetailLoaded) {
              final payment = state.payment;
              final isPending = payment.status.toLowerCase() == 'pending';

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentDetailCard(payment: payment),
                    const Spacer(),

                    if (isPending) ...[
                      PrimaryButton(
                        label: 'Continue Payment',
                        onPressed: () {
                          context.read<PaymentDetailBloc>().add(OpenPayment());
                        },
                      ),
                      const SizedBox(height: 12),
                      DangerButton(
                        label: 'Cancel Payment',
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Row(
                                children: const [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color.fromARGB(255, 172, 14, 3),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Cancel Payment',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Are you sure you want to cancel this payment?\n\n'
                                'This action cannot be undone.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.read<PaymentDetailBloc>().add(
                                        CancelAndReloadPayment(paymentId),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        172,
                                        14,
                                        3,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Yes, Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            }

            if (state is PaymentDetailError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 172, 14, 3),
                    fontSize: 20,
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
