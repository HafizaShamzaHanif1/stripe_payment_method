import 'package:flutter/material.dart';
import '../services/stripe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Stripe Payment Demo",
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlanButton(
              planName: "30 Days Plan",
              amount: 10,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            PlanButton(
              planName: "90 Days Plan",
              amount: 25,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            PlanButton(
              planName: "12 Months Plan",
              amount: 80,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class PlanButton extends StatelessWidget {
  final String planName;
  final int amount;
  final Color color;

  const PlanButton({
    Key? key,
    required this.planName,
    required this.amount,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        StripeService.instance.makePayment(amount);
      },
      color: color,
      child: Text(
        planName,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
