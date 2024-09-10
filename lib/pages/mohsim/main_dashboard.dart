import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/components/app%20bar/homepage_app_bar.dart';
import 'package:jahnhalle/components/drawer/my_drawer.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/home_page.dart';
import 'package:jahnhalle/pages/mohsim/checkout_screen.dart';
import 'package:jahnhalle/pages/mohsim/event_overview.dart';
import 'package:jahnhalle/pages/mohsim/model/event_card_model.dart';
import 'package:jahnhalle/pages/mohsim/offer_details.dart';
import 'package:jahnhalle/pages/mohsim/offers.dart';
import 'package:jahnhalle/pages/mohsim/utils/keys.dart';
import 'package:jahnhalle/pages/mohsim/utils/sp.dart';
import 'package:jahnhalle/themes/colors.dart';
import 'package:jahnhalle/widgets/image_widget.dart';

import '../../services/database/event.dart';
import '../../services/database/firestore.dart';
import '../order_page.dart';

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
  void initState() {
    super.initState();
    Future.microtask(() => showOfferDialoge());
  }

  Future showOfferDialoge() {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: FirebaseFirestore.instance.collection("offers").get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Dialog(
                    clipBehavior: Clip.hardEdge,
                    insetPadding: EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OfferDetailPage(id: snapshot.data?.docs[0].data()),
                      )),
                      child: AspectRatio(
                        aspectRatio: 0.8,
                        child: BannerWidget(
                          isPopUp: true,
                          isBorder: false,
                          data: snapshot.data?.docs[0].data(),
                          timeDiff: DateTime.parse((snapshot.data?.docs[1]
                                      .data()['end_time'] as Timestamp)
                                  .toDate()
                                  .toString())
                              .difference(
                            DateTime.parse(
                              (snapshot.data?.docs[0].data()['time']
                                      as Timestamp)
                                  .toDate()
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ));
  }

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
                  onTap: () async {
                    final pop = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderPage()),
                    );
                    if (pop == true) {
                      showOfferDialoge();
                    }
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
            child: InkWell(
              onTap: () async {
                final pop = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const OffersScreen(),
                ));
                if (pop == true) {
                  showOfferDialoge();
                }
              },
              child: Container(
                height: dimensions.height * 0.15,
                width: dimensions.width,
                padding: EdgeInsets.all(dimensions.width * 0.03),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
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
          ),
          SizedBox(
            height: dimensions.width * 0.03,
          ),
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       ElevatedButton(
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const OrderPage()),
          //           );
          //         },
          //         style: ElevatedButton.styleFrom(
          //           foregroundColor: Theme.of(context).colorScheme.onPrimary,
          //           backgroundColor: Theme.of(context).colorScheme.primary,
          //         ),
          //         child: const Text('Go to Order Page'),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: dimensions.width * 0.03,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Text(
              'Nächste Events',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          SizedBox(
            height: dimensions.width * 0.01,
          ),
          Container(
            height: dimensions.width * 0.63,
            padding: EdgeInsets.only(left: dimensions.width * 0.04),
            child: StreamBuilder<List<Event>>(
              stream: FirestoreService().streamEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        double rightPadding =
                            index == evet.length - 1 ? 20.0 : 8.0;
                        final event = snapshot.data?[index] as Event;
                        return Padding(
                          padding: EdgeInsets.only(right: rightPadding),
                          child: InkWell(
                              onTap: () async {
                                final pop = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EventOverview(
                                      event: event,
                                    ),
                                  ),
                                );
                                if (pop == true) {
                                  showOfferDialoge();
                                }
                              },
                              child: EventCard(event: event)),
                        );
                      });
                } else {
                  return const SizedBox();
                }
              },
            ),
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
          if (SP.i.getString(key: SPKeys.isLoggedIn) == null)
            SizedBox(
              height: dimensions.width * 0.03,
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimensions.width * 0.04),
            child: Column(
              children: [
                if (SP.i.getString(key: SPKeys.isLoggedIn) == null)
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

// class EventCard extends StatelessWidget {
//   final Event event;

//   const EventCard({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: dimensions.width * 0.75,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       width: 2.0),
//                   color: Colors.white,
//                 ),
//                 child: Image.asset(
//                   event.imageUrl ?? "",
//                   fit: BoxFit.cover,
//                   height: dimensions.height * 0.2,
//                   width: double.infinity,
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   event.name,
//                   style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Sa - ${event.date}',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
