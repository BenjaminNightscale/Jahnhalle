import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/services/database/event.dart';
import 'package:jahnhalle/utils/dimension.dart';
import 'package:jahnhalle/widgets/image_widget.dart';

class EventOverview extends StatefulWidget {
  final Event event;
  const EventOverview({super.key, required this.event});

  @override
  State<EventOverview> createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
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
            left: dimensions.width * 0.05,
            top: dimensions.width * 0.10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: SvgPicture.asset('assets/icons/backIcon.svg'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: dimensions.width * 0.08,
                left: dimensions.width * 0.04,
                right: dimensions.width * 0.04),
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
                              "${widget.event.tickets ?? "0"}€ Rabatt",
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
}
