import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/components/app%20bar/cart_app_bar.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/model/checkout_cart_model.dart';
import 'package:jahnhalle/pages/mohsim/payment_screen.dart';
import 'package:jahnhalle/themes/colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<CheckOutCartModel> cartItem = [
    CheckOutCartModel(
        title: 'COCA-COLA ZERO',
        subTitle: 'Coca-Cola Flasche 0,33l',
        amount: '3,90€',
        itemCount: '1'),
    CheckOutCartModel(
        title: 'PASSIONSFRUCHT',
        subTitle: 'hausgemachte Limonade 0,33l',
        amount: '4,20€',
        itemCount: '2'),
    CheckOutCartModel(
        title: 'SMOKY SALMON TOAST',
        subTitle:
            'getostetes, Schwarzbrot, Frischkäse, Spinat, Lachs, Kren, Pochiertes Ei',
        amount: '14,90€',
        itemCount: '2'),
  ];
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CartAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItem.length,
              itemBuilder: (context, index) {
                var item = cartItem[index];
                return Container(
                  width: dimensions.width * 0.45,
                  padding: EdgeInsets.all(dimensions.width * 0.03),
                  margin: EdgeInsets.all(dimensions.width * 0.03),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2.0),
                    color: scaffoldBackgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        item.subTitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.amount,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    count++;
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.all(dimensions.width * 0.0001),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        width: 2.0),
                                    color: scaffoldBackgroundColor,
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.remove,
                                    size: 20,
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: dimensions.width * 0.02,
                              ),
                              Text(
                                count.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: dimensions.width * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (count > 1) {
                                    setState(() {
                                      count--;
                                    });
                                  }
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.all(dimensions.width * 0.0001),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        width: 2.0),
                                    color: scaffoldBackgroundColor,
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.add,
                                    size: 20,
                                  )),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: dimensions.width,
            padding: EdgeInsets.all(dimensions.width * 0.05),
            // margin: EdgeInsets.all(dimensions.width * 0.03),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface, width: 2.0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Baseline(
                          baselineType: TextBaseline.alphabetic,
                          baseline: 20, // Adjust this value to align correctly
                          child: Text(
                            'TOTAL',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Baseline(
                          baselineType: TextBaseline.alphabetic,
                          baseline: 20, // Adjust this value to align correctly
                          child: Text(
                            'inkl. MwSt.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 20, // Adjust this value to align correctly
                      child: Text(
                        '42,10€',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: dimensions.width * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PaymentScreen(),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(dimensions.width * 0.01),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2.0),
                      color: scaffoldBackgroundColor,
                    ),
                    child: const Center(
                      child: Text(
                        'BEZAHLEN',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
