import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/components/footer/footer.dart';

import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/model/checkout_cart_model.dart';
import 'package:jahnhalle/pages/mohsim/model/payment_method_model.dart';
import 'package:jahnhalle/pages/mohsim/model/tips_model.dart';
import 'package:jahnhalle/pages/mohsim/order_overview.dart';
import 'package:jahnhalle/pages/mohsim/utils/payment_gateway.dart';
import 'package:jahnhalle/pages/overview_page.dart';
import 'package:jahnhalle/themes/colors.dart';
import 'package:jahnhalle/utils/dimension.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<TipsModel> tips = [
    TipsModel(percentage: '10%', amount: '4,20€'),
    TipsModel(percentage: '15%', amount: '6,30€'),
    TipsModel(percentage: '20%', amount: '8,40€')
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
  int selectedIndexTips = 0;
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
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    width: dimensions.width,
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
                          'Pius Martin - Tisch 30',
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
                          margin: EdgeInsets.all(dimensions.width * 0.03),
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
                                item.category,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item.price}€",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    "${item.quantity}x",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                        left: dimensions.width * 0.03,
                        top: dimensions.width * 0.05),
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
                    padding: EdgeInsets.only(left: dimensions.width * 0.03),
                    height: dimensions.height * 0.085,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: List.generate(
                        tips.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexTips = index;
                              });
                            },
                            child: Container(
                              width: dimensions.width * 0.4,
                              padding: EdgeInsets.all(dimensions.width * 0.02),
                              margin: EdgeInsets.only(
                                  right: dimensions.width * 0.03),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
                                      "${index == 0 ? (value.totalPrice % 10).toStringAsFixed(2) : index == 1 ? (value.totalPrice % 15).toStringAsFixed(2) : (value.totalPrice % 20).toStringAsFixed(2)}€",
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
                  Padding(
                    padding: EdgeInsets.only(left: dimensions.width * 0.03),
                    child: const Text(
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
                    padding: EdgeInsets.only(left: dimensions.width * 0.03),
                    height: dimensions.height * 0.12,
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
                              width: dimensions.width * 0.5,
                              padding: EdgeInsets.all(dimensions.width * 0.02),
                              margin: EdgeInsets.only(
                                  right: dimensions.width * 0.03),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    width: 2.0),
                                color: selectedIndex == index
                                    ? Colors.black
                                    : scaffoldBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                onPress: () async {
                  if (value.items.isNotEmpty) {
                    await value.addOrder(context).then(
                          (value) {},
                        );
                  }
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}
