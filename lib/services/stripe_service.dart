import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ccsp/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(int amount) async {
    try {
      // Step 1: Create Payment Intent
      String? paymentIntentClientSecret = await _createPaymentIntent(amount, "usd");
      if (paymentIntentClientSecret == null) {
        print("Failed to get Payment Intent Client Secret");
        return;
      }

      // Step 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Shamza Hanif",
        ),
      );

      // Step 3: Present Payment Sheet
      await _processPayment();
    } catch (e) {
      print("Error during payment: $e");
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print("Error creating Payment Intent: $e");
      return null;
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment successful!");
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print("Error presenting Payment Sheet: $e");
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Convert to cents for Stripe
    return calculatedAmount.toString();
  }
}
