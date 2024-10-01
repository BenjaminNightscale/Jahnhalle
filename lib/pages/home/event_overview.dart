import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/services/database/event.dart';
import 'package:jahnhalle/components/utils/dimension.dart';
import 'package:jahnhalle/components/widgets/image_widget.dart';

class EventOverview extends StatefulWidget {
  final Event event;
  const EventOverview({super.key, required this.event});

  @override
  State<EventOverview> createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  @override
  void initState() {
    findDay(widget.event.date);
    log("message ${widget.event.discount}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: dimensions.height * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(dimensions.width * 0.04),
                  bottomRight: Radius.circular(dimensions.width * 0.04),
                ),
                image: DecorationImage(
                    image: NetworkImage(widget.event.imageUrl ?? ''),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: dimensions.width * 0.13,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: SvgPicture.asset('assets/icons/backIcon.svg'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: dimensions.width * 0.08, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: dimensions.width,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: const Color(0xffE4EDCA),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: dimensions.width * 0.02),
                      Row(
                        children: [
                          containerBox(widget.event.date),
                          containerBox(findDay(widget.event.date)),
                          containerBox("ab ${getTime(widget.event.time)}"),
                        ],
                      ),
                      SizedBox(height: dimensions.width * 0.03),
                      Text(
                        widget.event.eventDetails,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1),
                      ),
                      SizedBox(
                        height: dimensions.width * 0.02,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: dimensions.width * 0.04,
                ),
                Container(
                  width: dimensions.width,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: const Color(0xffE4EDCA),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.event.discount}€ Rabatt",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: dimensions.width * 0.045),
                            ),
                            Text(
                              "Voucher für Pizza und Co",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: dimensions.width * 0.03),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(border: Border.all(width: 2)),
                        child: const Text(
                          "VOUCHER",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String findDay(String date) {
    // Date string in the format "dd.MM"
    String dateString = date;
    // Assuming current year
    int currentYear = DateTime.now().year;
    // Parse the date string
    DateFormat dateFormat = DateFormat("dd.MM");
    DateTime parsedDate = dateFormat.parse("$dateString.$currentYear");
    // Get the weekday (1 = Monday, 7 = Sunday)
    int weekday = parsedDate.weekday;
    // Map the weekday number to the name of the day
    List<String> weekdays = [
      "Montag", // Monday
      "Dienstag", // Tuesday
      "Mittwoch", // Wednesday
      "Donnerstag", // Thursday
      "Freitag", // Friday
      "Samstag", // Saturday
      "Sonntag" // Sunday
    ];
    return weekdays[weekday - 1];
  }

  String getTime(String time) {
    String timeRange = time;
    // Split the string at the " - " delimiter and get the first part
    String firstTime = timeRange.split(" - ")[0];
    print(firstTime); // Output: 20:00
    return firstTime;
  }

  Widget containerBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1),
      ),
    );
  }
}
