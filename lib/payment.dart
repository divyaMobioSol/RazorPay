import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razor_pay/widget/textFormfield.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Razorpay? _razorpay;

  final price = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //_razorpay!.on(Razorpay.PAYMENT_CANCELLED, _handlePaymentSuccess);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': double.parse(price.text + '00'),
      'name': name.text,
      'description': 'Payment',
      'prefill': {'contact': mobile.text, 'email': email.text},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId}", timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName}", timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Card(
                child: TextFormFieldWidget(
                    hintText: 'Enter Price',
                    controller: price,
                    textInputType: TextInputType.number,
                    text: 'price required')),
            Card(
                child: TextFormFieldWidget(
                    hintText: 'Enter Name',
                    controller: name,
                    textInputType: TextInputType.name,
                    text: 'name required')),
            Card(
                child: TextFormFieldWidget(
                    hintText: 'Enter Mobile Number',
                    controller: mobile,
                    textInputType: TextInputType.phone,
                    text: 'phone required')),
            Card(
                child: TextFormFieldWidget(
                    hintText: 'Enter Email',
                    controller: email,
                    textInputType: TextInputType.emailAddress,
                    text: 'email required')),
            SizedBox(height: 20.0),
            InkWell(
                onTap: () {
                  openCheckout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFFF17532)),
                      child: const Center(
                          child: Text('Checkout',
                              style: TextStyle(
                                  fontFamily: 'nunito',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                ))
          ]),
        ),
      ),
    );
  }
}
