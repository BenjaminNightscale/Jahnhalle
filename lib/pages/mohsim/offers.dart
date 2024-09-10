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
        automaticallyImplyLeading: false, // Remove the default back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
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
                      child: BannerWidget(
                        data: data[index],
                        timeDiff: timeDiff,
                      ),
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
      this.isBorder = true,
      this.isPopUp = false});

  final dynamic data;
  final isBorder;
  final bool isPopUp;
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
      decoration: BoxDecoration(
        border: widget.isBorder ? Border.all(width: 2) : null,
        image: DecorationImage(
          image: NetworkImage(
            widget.isPopUp
                ? widget.data["banner_image"]
                : widget.data["banner_url"],
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: dimensions.width * 0.05,
          ),
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
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                SizedBox(
                  height: dimensions.width * 0.015,
                ),
                Flexible(
                  child: Text(
                    widget.data['subtitle'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: dimensions.width * 0.025,
                ),
                Row(
                  children: [
                    ImageWidget(
                      url: "assets/icons/clock.svg",
                      height: 18,
                      width: 18,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "ENDET ${_formatDuration(widget.timeDiff ?? Duration.zero)}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: dimensions.width * 0.1)
              ],
            ),
          ),
          SizedBox(
            width: dimensions.width * 0.3,
          ),
        ],
      ),
    );
  }
}
