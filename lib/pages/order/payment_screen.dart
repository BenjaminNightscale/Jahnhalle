import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jahnhalle/services/database/cart.dart';
import 'package:jahnhalle/components/footer/footer.dart';

import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/services/model/checkout_cart_model.dart';
import 'package:jahnhalle/services/model/payment_method_model.dart';
import 'package:jahnhalle/services/model/tips_model.dart';
import 'package:jahnhalle/pages/order/order_overview.dart';
import 'package:jahnhalle/components/utils/payment_gateway.dart';
import 'package:jahnhalle/components/themes/colors.dart';
import 'package:jahnhalle/components/utils/dimension.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<TipsModel> tips = [
    TipsModel(percentage: '10%', amount: ''),
    TipsModel(percentage: '15%', amount: ''),
    TipsModel(percentage: '20%', amount: '')
  ];

  List<PaymentMethodModel> payment = [
    PaymentMethodModel(
        method: 'Apple Pay',
        discription: 'einfach bezahlen über deine Apple Wallet'),
    PaymentMethodModel(
        method: 'Barzahlung',
        discription: 'direkt Bar bei unseren Mitarbeiter:innen bezahlen'),
    PaymentMethodModel(
        method: 'PayPal',
        discription: 'simple und schnell über Paypal bezahlen')
  ];
  int selectedIndex = 0;
  int selectedIndexTips = -1;
  @override
  void initState() {
    tips = tips.map((tip) {
      double percentageValue =
          double.parse(tip.percentage.replaceAll('%', '')) / 100;
      double calculatedAmount = context.read<Cart>().subtotal * percentageValue;

      return TipsModel(
        percentage: tip.percentage,
        amount: calculatedAmount.toStringAsFixed(2),
      );
    }).toList();
    for (var tip in tips) {
      print('Tip: ${tip.percentage}, Amount: ${tip.amount}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the default back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          "BEZAHLEN",
          style: TextStyle(
            fontFamily: 'Roquefort',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<Cart>(builder: (context, value, _) {
        if (value.isAddingOrder) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: dimensions.width,
                      padding: EdgeInsets.all(dimensions.width * 0.03),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0)
                          .copyWith(top: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 2.0),
                        color: scaffoldBackgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BESTELLDETAILS',
                            style: TextStyle(
                              fontFamily: 'Roquefort',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Pius Martin - ${context.read<Cart>().tableNumber}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(
                        value.items.length,
                        (index) {
                          var item = value.items[index];

                          return Container(
                            width: dimensions.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            color: scaffoldBackgroundColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                Text(
                                  item.ingredients.join(', '),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.price.toStringAsFixed(2)}€",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      "${item.quantity}x",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, top: dimensions.width * 0.04),
                      child: const Text(
                        'TRINKGELD',
                        style: TextStyle(
                          fontFamily: 'Roquefort',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dimensions.width * 0.03,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      height: dimensions.height * 0.075,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: List.generate(
                          tips.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedIndexTips == index) {
                                    selectedIndexTips = -1;
                                  } else {
                                    selectedIndexTips = index;
                                  }
                                });
                              },
                              child: Container(
                                width: dimensions.width * 0.3,
                                padding:
                                    EdgeInsets.all(dimensions.width * 0.02),
                                margin: EdgeInsets.only(
                                    right: dimensions.width * 0.03),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      width: 2.0),
                                  color: selectedIndexTips == index
                                      ? Colors.black
                                      : scaffoldBackgroundColor,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      tips[index].percentage,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: selectedIndexTips == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${tips[index].amount}€",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: selectedIndexTips == index
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dimensions.width * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: dimensions.width * 0.1),
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: dimensions.width * 0.05,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'BEZAHLMETHODE',
                        style: TextStyle(
                          fontFamily: 'Roquefort',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dimensions.width * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: List.generate(
                          payment.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                width: dimensions.width * 0.4,
                                padding:
                                    EdgeInsets.all(dimensions.width * 0.04),
                                margin: EdgeInsets.only(
                                    right: dimensions.width * 0.03),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      width: 2.0),
                                  color: selectedIndex == index
                                      ? Colors.black
                                      : scaffoldBackgroundColor,
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        payment[index].method,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Expanded(
                                        child: Text(
                                          payment[index].discription,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) {
        return value.items.isNotEmpty
            ? Footer(
                buttonText: 'BEZAHLEN'.toUpperCase(),
                tipAmount: selectedIndexTips == -1
                    ? null
                    : double.parse(tips[selectedIndexTips].amount),
                onPress: () async {
                  if (value.items.isNotEmpty) {
                    value.updateisAddingOrder(true);
                    await value.addOrder(context).then(
                      (_) {
                        value.updateisAddingOrder(false);
                      },
                    );
                  }
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}
