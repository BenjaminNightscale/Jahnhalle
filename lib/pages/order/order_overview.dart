import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/services/database/cart.dart';
import 'package:jahnhalle/components/footer/footer.dart';

import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/home/main_dashboard.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:jahnhalle/components/themes/colors.dart';
import 'package:jahnhalle/components/utils/dimension.dart';
import 'package:jahnhalle/components/widgets/image_widget.dart';
import 'package:provider/provider.dart';

import '../../services/model/order_detail_model.dart';

class OrderOverviewScreen extends StatefulWidget {
  final int orderID;
  const OrderOverviewScreen({super.key, required this.orderID});

  @override
  State<OrderOverviewScreen> createState() => _OrderOverviewScreenState();
}

class _OrderOverviewScreenState extends State<OrderOverviewScreen> {
  OrderDetail? orderDetail;
  Timer? _timer;
  bool isDeletePopup = false;
  @override
  void initState() {
    _startUpdateTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startUpdateTimer() {
    log("_startUpdateTimer");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Fetch the latest order details and update the status
        context.read<Cart>().streamOrderDetails(widget.orderID).listen((order) {
          if (order != null) {
            orderDetail = order;
            if (order.isDeleted == true) {
              if (isDeletePopup == false) {
                showDeleteOrderPopUp();
                order.items?.forEach(
                  (element) {
                    context.read<Cart>().restockDrink(
                        drinkId: element.id ?? '',
                        quantity: element.quantity ?? 0);
                  },
                );
              }
            }
            updateStatus(order.status ?? '');
          }
        });
      });
    });
  }

  Future showDeleteOrderPopUp() {
    isDeletePopup = true;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              side: BorderSide(width: 2),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Gelöscht',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ihre Bestellung wurde gelöscht.',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainDashboard(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Ok',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontSize: 14),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the default back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainDashboard(),
              ),
              (route) => false,
            );
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
            orderDetail == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display items
                      const SizedBox(
                        height: 10.0,
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: orderDetail?.items?.length,
                        itemBuilder: (context, index) {
                          final item = orderDetail?.items?[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${item?.quantity.toString()}x ",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      item?.name?.toUpperCase() ?? '',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                Text(
                                  item?.category ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),

                      Container(
                        width: dimensions.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
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
                                Text(
                                  "PIUS MARTIN - ${orderDetail?.table?.tableNumber}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Display table details

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                    ],
                  ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: dimensions.width * 0.03),
              child: OrderTimeline(statuses: statuses),
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
        return Footer(
          showTotal: false,
          buttonText: 'HAUPTMENÜ'.toUpperCase(),
          onPress: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainDashboard(),
              ),
              (route) => false,
            );
            // showDeleteOrderPopUp();
          },
        );
      },
    );
  }

  List<OrderStatus> statuses = [
    OrderStatus(
      title: 'Bestellung angenommen',
      date: '5 JULY',
      time: '21:32',
      isCompleted: true,
    ),
    OrderStatus(
      title: 'Bestellung in Bearbeitung',
      date: '5 JULY',
      time: '21:33',
      isCompleted: false,
    ),
    OrderStatus(
      title: 'Bestellung geliefert',
      date: '5 JULY',
      time: '21:34',
      isCompleted: false,
    ),
  ];

  void _completeNextStep() {
    // Find the next incomplete step
    for (int i = 0; i < statuses.length; i++) {
      if (statuses[i].isCompleted) {
        setState(() {
          statuses[i].isCompleted = true;
        });
        break;
      }
    }
  }

  void updateStatus(String status) {
    log("updateStatus:- $status");
    setState(() {
      statuses[0].date = formatTimestamp(orderDetail!.createdAt!);
      statuses[0].time = formatTime(orderDetail!.createdAt!);
      if (status == "Bestellung in Bearbeitung") {
        statuses[1].isCompleted = true;
        statuses[1].date = formatTimestamp(orderDetail!.updatedAt!);
        statuses[1].time = formatTime(orderDetail!.updatedAt!);
      }
      if (status == "Bestellung geliefert") {
        statuses[2].isCompleted = true;
        statuses[2].date = formatTimestamp(orderDetail!.deliveredAt!);
        statuses[2].time = formatTime(orderDetail!.deliveredAt!);
      }
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to the desired string format '5 JULY'
    String formattedDate =
        DateFormat('d MMMM', 'en_US').format(dateTime).toUpperCase();

    return formattedDate;
  }

  String formatTime(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to the desired string format '21:32'
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }
}

class OrderTimeline extends StatelessWidget {
  final List<OrderStatus> statuses;

  const OrderTimeline({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: statuses.map((status) => _buildTimelineItem(status)).toList(),
    );
  }

  Widget _buildTimelineItem(OrderStatus status) {
    return Consumer<Cart>(builder: (context, value, _) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle and line
          Column(
            children: [
              _buildAnimatedCircle(status.isCompleted),
              if (statuses.last != status)
                _buildLine(), // Draw line only if it's not the last item
            ],
          ),
          const SizedBox(width: 8),
          // Status text and timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Visibility(
            visible: status.isCompleted,
            child: Column(
              children: [
                Text(' ${status.date}'),
                Text(' ${status.time}'),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget _buildAnimatedCircle(bool isCompleted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? Colors.black : Colors.transparent,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      // Add a checkmark if completed
    );
  }

  Widget _buildLine() {
    return Container(
      width: 2,
      height: 40,
      color: Colors.black,
    );
  }
}

class OrderStatus {
  String title;
  String date;
  String time;
  bool isCompleted;

  OrderStatus({
    required this.title,
    required this.date,
    required this.time,
    required this.isCompleted,
  });
}
