import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:client/navigation/main_page.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String url;

  const PaymentWebViewPage({super.key, required this.url});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _handledResult = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },

          onPageFinished: (url) async {
            setState(() => _isLoading = false);

            if (_handledResult) return;

            if (url.contains('transaction_status=settlement') ||
                url.contains('status_code=200')) {
              _handledResult = true;
              _handleSuccess();
            }

            if (url.contains('transaction_status=cancel')) {
              _handledResult = true;
              _handleCancel();
            }

            if (url.contains('transaction_status=deny') ||
                url.contains('transaction_status=expire')) {
              _handledResult = true;
              _handleFailed();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _handleSuccess() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment successful. 🎉'),
        backgroundColor: Color.fromARGB(255, 4, 80, 20),
      ),
    );
  }

  void _handleCancel() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment cancelled.'),
        backgroundColor: Color.fromARGB(255, 172, 14, 3),
      ),
    );
  }

  void _handleFailed() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment failed. Please try again.'),
        backgroundColor: Color.fromARGB(255, 33, 33, 33),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // disable default back
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final navigator = Navigator.of(context);

        final canGoBack = await _controller.canGoBack();

        if (!mounted) return;

        if (canGoBack) {
          _controller.goBack();
        } else {
          navigator.pop();
        }
      },

      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Payment',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainPage()),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment pending.'),
                  backgroundColor: Color.fromARGB(255, 187, 115, 7),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 172, 14, 3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
