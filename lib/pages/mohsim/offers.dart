import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/offer_details.dart';
import 'package:jahnhalle/widgets/image_widget.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE4EDCA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ANGEBOTE",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("offers").get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              List<QueryDocumentSnapshot> data = snapshot.data?.docs ?? [];

              return ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final timeDiff = DateTime.parse(
                            (data[index]['end_time'] as Timestamp)
                                .toDate()
                                .toString())
                        .difference(DateTime.parse(
                            (data[index]['time'] as Timestamp)
                                .toDate()
                                .toString()));

                    log(timeDiff.toString());
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OfferDetailPage(id: data[index].data()),
                      )),
                      child:
                          BannerWidget(data: data[index], timeDiff: timeDiff),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: data.length);
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}

class BannerWidget extends StatefulWidget {
  BannerWidget(
      {super.key,
      required this.data,
      required this.timeDiff,
      this.isBorder = true});

  final dynamic data;
  final isBorder;
  Duration? timeDiff;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (tick) {
      if ((widget.timeDiff?.inSeconds ?? 0) <= 0) {
        timer?.cancel();
      } else {
        setState(() {
          widget.timeDiff =
              (widget.timeDiff ?? Duration.zero) - const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimensions.width,
      height: dimensions.width * 0.5,
      decoration:
          BoxDecoration(border: widget.isBorder ? Border.all(width: 2) : null),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned.fill(
            child: ImageWidget(
              url: widget.data["banner_url"],
              width: dimensions.width,
              height: dimensions.width * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 22),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.data['subtitle'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Row(
                        children: [
                          ImageWidget(
                            url: "assets/icons/clock.svg",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              "ENDET ${_formatDuration(widget.timeDiff ?? Duration.zero)}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: dimensions.width * 0.3,
                )
              ],
            ),
          )
          // Text(
          //   timeDiff.toString(),
          //   style: TextStyle(
          //       fontSize: 18, fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }
}
