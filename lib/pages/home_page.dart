import 'package:flutter/material.dart';
import 'package:jahnhalle/components/app%20bar/homepage_app_bar.dart';
import 'package:jahnhalle/components/drawer/my_drawer.dart';
import 'package:jahnhalle/pages/order_page.dart';
import 'package:jahnhalle/services/database/event.dart';
import 'package:jahnhalle/services/database/firestore.dart';
import 'package:jahnhalle/themes/colors.dart';
import 'package:jahnhalle/widgets/image_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          HomePageAppBar(title: widget.title), // Use the custom HomePageAppBar
      drawer: const CustomDrawer(), // Use the custom drawer
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                  color: scaffoldBackgroundColor,
                ),
              ),
              Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Go to Order Page'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: _firestoreService.streamEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading events'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events available'));
                }

                List<Event> events = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    double leftPadding = index == 0 ? 20.0 : 8.0;
                    double rightPadding =
                        index == events.length - 1 ? 20.0 : 8.0;
                    return Padding(
                      padding: EdgeInsets.only(
                          left: leftPadding, right: rightPadding),
                      child: EventCard(event: events[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                color: Colors.white,
              ),
              child: event.imageUrl != null
                  ? Image.network(
                      event.eventImage ?? '',
                      fit: BoxFit.cover,
                      height: 160,
                      width: double.infinity,
                    )
                  : Container(
                      height: 160,
                      color: Colors.grey,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                // const SizedBox(height: 2),
                Text(
                  'Sa - ${event.date}',
                  style: const TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
