import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/components/my_timeline_tile.dart';

import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/model/checkout_cart_model.dart';
import 'package:jahnhalle/pages/mohsim/model/payment_method_model.dart';
import 'package:jahnhalle/pages/mohsim/model/tips_model.dart';
import 'package:jahnhalle/themes/colors.dart';
import 'package:jahnhalle/utils/dimension.dart';
import 'package:jahnhalle/widgets/image_widget.dart';
import 'package:provider/provider.dart';

class OrderOverviewScreen extends StatefulWidget {
  const OrderOverviewScreen({super.key});

  @override
  State<OrderOverviewScreen> createState() => _OrderOverviewScreenState();
}

class _OrderOverviewScreenState extends State<OrderOverviewScreen> {
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
          "BESTELLÜBERSICHT",
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
                padding: EdgeInsets.only(top: dimensions.height * 0.02),
                children: [
                  Column(
                    children: List.generate(
                      value.items.length,
                      (index) {
                        var item = value.items[index];

                        return Container(
                          width: dimensions.width,
                          margin: EdgeInsets.only(
                              left: dimensions.width * 0.03,
                              right: dimensions.width * 0.03,
                              bottom: dimensions.width * 0.02),
                          color: scaffoldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${item.quantity}x",
                                    style: const TextStyle(
                                        fontFamily: 'Roquefort',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: dimensions.width * 0.01,
                                  ),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                item.ingredients.join(","),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: dimensions.width * 0.03),
                    child: const Divider(),
                  ),
                  SizedBox(
                    height: dimensions.width * 0.03,
                  ),
                  Container(
                    width: dimensions.width,
                    margin: EdgeInsets.all(dimensions.width * 0.03),
                    color: scaffoldBackgroundColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageWidget(
                          url: 'assets/icons/ion_location-outline.svg',
                          height: dimensions.width * 0.05,
                        ),
                        SizedBox(
                          width: dimensions.width * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "von",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Text(
                              "JAHNHALLE HAUPTBAR",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: dimensions.width,
                    margin: EdgeInsets.all(dimensions.width * 0.03),
                    color: scaffoldBackgroundColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageWidget(
                          url: 'assets/icons/carbon_bar.svg',
                          height: dimensions.width * 0.05,
                        ),
                        SizedBox(
                          width: dimensions.width * 0.03,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "an",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Text(
                              "PIUS MARTIN - TISCH 30",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: dimensions.width * 0.03,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: dimensions.width * 0.03),
                      child: const Divider()),
                  SizedBox(
                    height: dimensions.width * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: dimensions.width * 0.03),
                    child: const Column(
                      children: [
                        MyTimelineTile(
                          isFirst: true,
                          isLast: false,
                          event: 'Bestellung angenommen',
                          isPast: true,
                          isreached: true,
                        ),
                        MyTimelineTile(
                          isFirst: false,
                          isLast: false,
                          event: 'Bestellung in Bearbeitung',
                          isPast: true,
                          isreached: true,
                        ),
                        MyTimelineTile(
                          isFirst: false,
                          isLast: true,
                          event: 'Bestellung geliefert',
                          isPast: false,
                          isreached: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: dimensions.width,
              padding: EdgeInsets.all(dimensions.width * 0.08),
              // margin: EdgeInsets.all(dimensions.width * 0.03),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                ),
              ),
              child: GestureDetector(
                onTap: () {},
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
                      'HAUPTMENÜ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
