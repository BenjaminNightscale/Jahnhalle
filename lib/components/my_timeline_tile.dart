import 'package:flutter/material.dart';
import 'package:jahnhalle/main.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String? event;
  final String? eventtime;
  final bool? isreached;
  const MyTimelineTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      this.event,
      this.eventtime,
      this.isreached});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimensions.height * 0.08,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(color: isPast ? Colors.black : Colors.grey),
        indicatorStyle:
            IndicatorStyle(color: isPast ? Colors.black : Colors.grey),
        endChild: Padding(
          padding: EdgeInsets.only(left: dimensions.width * 0.03),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event ?? "",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
              isreached == true
                  ? const Baseline(
                      baseline: 26,
                      baselineType: TextBaseline.ideographic,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('5 JULY', style: TextStyle(fontSize: 10)),
                          Text('21:33', style: TextStyle(fontSize: 10))
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
