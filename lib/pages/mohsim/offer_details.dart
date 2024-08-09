// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/components/drink_item.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/offers.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:jahnhalle/widgets/image_widget.dart';

class OfferDetailPage extends StatefulWidget {
  dynamic id;

  OfferDetailPage({super.key, required this.id});

  @override
  State<OfferDetailPage> createState() => _OfferDetailPageState();
}

class _OfferDetailPageState extends State<OfferDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE4EDCA),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            BannerWidget(
                data: widget.id,
                timeDiff: DateTime.parse((widget.id['end_time'] as Timestamp)
                        .toDate()
                        .toString())
                    .difference(DateTime.parse(
                        (widget.id['time'] as Timestamp).toDate().toString()))),
            const SizedBox(height: 20),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("drinks")
                  .where(FieldPath.documentId,
                      whereIn: (widget.id['products_under_offer'] as String)
                          .split(","))
                  .get(),
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final drink = snapshot.data?.docs[index].data();
                        return DrinkItem(
                            drink: Drink(
                                id: "0",
                                name: drink?['name'],
                                category: drink?['category'],
                                price: drink?['price'],
                                imageUrl: drink?['imageUrl'],
                                ingredients: (drink?['ingredients'] as List)
                                    .map<String>((e) => e)
                                    .toList()));
                      },
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemCount: snapshot.data?.docs.length ?? 0),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
