import 'dart:convert';
import 'dart:developer';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PaymentGateway {
  static final instance = PaymentGateway();

  String secretKey = "";
  String publishKey = "";

  String addPaymentMethod = 'https://api.stripe.com/v1/payment_intents';

  PaymentGateway() {
    secretKey =
        'sk_test_51P6zuhRqMnrUhHfkUVqir9My7sWBJdxG2iGLm9HZ7PME8k8DbeQQeLIyNrTWtvmVmRlM2F7BvXaBLXEYpoJVsCY700U3Tr995U';

    publishKey =
        'pk_test_51P6zuhRqMnrUhHfkhrYOeFMcu9B62ylVKNwvmRFjXnF0za62HJMhlE0K04DZCOWAFBEA7orymPzLHFPfMCYVyExE00WEDimvo9';

    Stripe.publishableKey = publishKey;
    // Stripe.stripeAccountId = "acct_1PK88KIgGA7vGdBP";
  }
  Future<PaymentMethod?> createPaymentMethod(String payment) async {
    return await Stripe.instance.createPaymentMethod(
        params: payment == "card"
            ? const PaymentMethodParams.card(
                paymentMethodData: PaymentMethodData())
            : const PaymentMethodParams.payPal(
                paymentMethodData: PaymentMethodData()));
  }

  Future<void> createPaymentIntent(String payment, String paymentMethod) async {
    try {
      final method = await createPaymentMethod(payment);
      final response = await http.post(
        Uri.parse(addPaymentMethod),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'payment_method': method?.id,
          "return_url": "https://stripe.com/docs/error-codes/url-invalid",
          'amount': (int.parse(payment) * 100).toString(),
          "currency": "eur",
          "confirm": "true",
        },
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                merchantDisplayName: "JAHNHALLE",
                paymentIntentClientSecret: jsonBody["client_secret"]));

        await Stripe.instance.presentPaymentSheet();
      } else {
        log(response.body);
        // alert(
        //     type: AlertType.error,
        //     message: 'Failed to create customer: ${response.body}');
      }
    } catch (e) {
      log("$e");
      // alert(type: AlertType.error, message: "$e");
    } finally {
      // Loader.hide();
      // AppNavigator.getContext().read<WalletProvider>().getPaymentLog();
    }
  }
}
