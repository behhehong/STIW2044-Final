import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tutor/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  final User user;
  final double totalamount;
  const Payment({Key? key, required this.user, required this.totalamount})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back_outlined),
        //     onPressed: () {
        //       backhomepage();
        //     }),
        title: Text('Payment'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'https://hubbuddies.com/271513/myTutor/php/generateBill.php?email=' +
                          widget.user.email.toString() +
                          '&name=' +
                          widget.user.username.toString() +
                          '&phone=' +
                          widget.user.phoneNum.toString() +
                          '&amount=' +
                          widget.totalamount.toString(),
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
