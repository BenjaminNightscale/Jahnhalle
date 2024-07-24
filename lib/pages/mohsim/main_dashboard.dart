import 'package:flutter/material.dart';
import 'package:jahnhalle/components/app%20bar/homepage_app_bar.dart';
import 'package:jahnhalle/components/drawer/my_drawer.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/checkout_screen.dart';
import 'package:jahnhalle/pages/mohsim/model/event_card_model.dart';
import 'package:jahnhalle/themes/colors.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  List<EventCardModel> evet = [
    EventCardModel(
      image: 'assets/images/Frame 4.png',
      title: 'JAZZ NIGHT',
      subTitle: '17.08.',
    ),
    EventCardModel(
      image: 'assets/images/Frame 4.png',
      title: 'PIZZA',
      subTitle: '24.08.',
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePageAppBar(
        title: '',
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CheckoutScreen(),
                    ));
                  },
                  child: Container(
                    height: dimensions.height * 0.15,
                    width: dimensions.width * 0.45,
                    padding: EdgeInsets.all(dimensions.width * 0.03),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 2.0),
                        color: scaffoldBackgroundColor,
                        image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/Mask group (3).png',
                            ),
                            alignment: Alignment.bottomRight)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BESTELLEN',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          'Drinks, Essen,etc',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: dimensions.height * 0.15,
                  width: dimensions.width * 0.45,
                  padding: EdgeInsets.all(dimensions.width * 0.03),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2.0),
                      color: scaffoldBackgroundColor,
                      image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/Pizza Box Mockup 3.png',
                          ),
                          alignment: Alignment.bottomRight)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABHOLEN',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        'Drinks, Essen,etc',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: dimensions.width * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Container(
              height: dimensions.height * 0.15,
              width: dimensions.width,
              padding: EdgeInsets.all(dimensions.width * 0.03),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                color: scaffoldBackgroundColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ANGEBOTE',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          'Tagesaktuell sparen',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/ambitious-studio-rick-barrett-ER7pZ6pebss-unsplash 1.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: dimensions.width * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Text(
              'Nächste Events',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Container(
            height: dimensions.width * 0.63,
            padding: EdgeInsets.only(left: dimensions.width * 0.04),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: evet.length,
                itemBuilder: (context, index) {
                  double rightPadding = index == evet.length - 1 ? 20.0 : 8.0;
                  return Padding(
                    padding: EdgeInsets.only(right: rightPadding),
                    child: EventCard(event: evet[index]),
                  );
                }),
          ),
          SizedBox(
            height: dimensions.width * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Container(
              width: dimensions.width,
              padding: EdgeInsets.all(dimensions.width * 0.03),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                color: scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5€ GESCHENKT',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    'Empfehl uns weiter für eine 5€ Bonus',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: dimensions.width * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Column(
              children: [
                Container(
                  height: dimensions.height * 0.05,
                  width: dimensions.width,
                  padding: EdgeInsets.all(dimensions.width * 0.02),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2.0),
                    color: scaffoldBackgroundColor,
                  ),
                  child: const Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: dimensions.height * 0.05,
                        width: dimensions.width,
                        padding: EdgeInsets.all(dimensions.width * 0.02),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2.0),
                            left: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2.0),
                            right: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2.0),
                          ),
                          color: scaffoldBackgroundColor,
                        ),
                        child: const Center(
                          child: Text(
                            'IMPRESSUM',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: dimensions.height * 0.05,
                        width: dimensions.width,
                        padding: EdgeInsets.all(dimensions.width * 0.02),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2.0),
                            bottom: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2.0),
                          ),
                          color: scaffoldBackgroundColor,
                        ),
                        child: const Center(
                          child: Text(
                            'WEBSITE',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: dimensions.width * 0.03,
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventCardModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimensions.width * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                  color: Colors.white,
                ),
                child: Image.asset(
                  event.image,
                  fit: BoxFit.cover,
                  height: dimensions.height * 0.2,
                  width: double.infinity,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sa - ${event.subTitle}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
