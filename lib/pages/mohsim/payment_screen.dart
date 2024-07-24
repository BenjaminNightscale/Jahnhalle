import 'package:flutter/material.dart';

import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/model/checkout_cart_model.dart';
import 'package:jahnhalle/pages/mohsim/model/payment_method_model.dart';
import 'package:jahnhalle/pages/mohsim/model/tips_model.dart';
import 'package:jahnhalle/pages/mohsim/order_overview.dart';
import 'package:jahnhalle/themes/colors.dart';
import 'package:jahnhalle/utils/dimension.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<CheckOutCartModel> items = [
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
      body: Column(
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
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Pius Martin - Tisch 30',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                    items.length,
                    (index) {
                      var item = items[index];

                      return Container(
                        width: dimensions.width,
                        margin: EdgeInsets.all(dimensions.width * 0.03),
                        color: scaffoldBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
                                Text(
                                  "${item.itemCount}x",
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                            margin:
                                EdgeInsets.only(right: dimensions.width * 0.03),
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
                                    tips[index].amount,
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
                  padding: EdgeInsets.only(right: dimensions.width * 0.2),
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
                  height: dimensions.height * 0.1,
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
                            margin:
                                EdgeInsets.only(right: dimensions.width * 0.03),
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
                              children: [
                                Text(
                                  payment[index].method,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                Expanded(
                                  child: Text(
                                    payment[index].discription,
                                    style: const TextStyle(
                                      fontSize: 12,
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '42,10€',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: dimensions.width * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OrderOverviewScreen(),
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
