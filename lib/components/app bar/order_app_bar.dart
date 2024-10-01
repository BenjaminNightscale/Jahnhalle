import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/services/database/cart.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/order/checkout_screen.dart';
import 'package:provider/provider.dart';

class OrderAppBar extends StatefulWidget {
  const OrderAppBar({super.key});

  @override
  State<OrderAppBar> createState() => _OrderAppBarState();
}

class _OrderAppBarState extends State<OrderAppBar> {
  Future showTableDialoge() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => FutureBuilder(
        future: FirebaseFirestore.instance.collection("tables").get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> tableDocs =
                snapshot.data!.docs.map((doc) => doc).toList()
                  ..sort((a, b) {
                    int aNumber = int.parse(a["tableNumber"].split(' ')[1]);
                    int bNumber = int.parse(b["tableNumber"].split(' ')[1]);
                    return aNumber.compareTo(bNumber);
                  });
            return Dialog(
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                side: BorderSide(width: 2),
              ),
              child: Container(
                height: dimensions.width * 0.08,
                width: dimensions.width * 0.5,
                margin:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                child: InkWell(
                  onTap: () async {
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;

                    final selectedTable = await showMenu(
                      constraints:
                          BoxConstraints(minWidth: dimensions.width * 0.5),
                      context: context,
                      position: RelativeRect.fromLTRB(
                        overlay.size.width / 2 - dimensions.width * 0.01,
                        overlay.size.height / 1.85,
                        overlay.size.width / 2 - dimensions.width * 0.25,
                        overlay.size.height / 2 - dimensions.width * 0.01,
                      ),
                      items: tableDocs.map((doc) {
                        return PopupMenuItem<Map<String, dynamic>>(
                          value: {
                            "tableNumber": doc['tableNumber'],
                            'capacity': doc['capacity']
                          },
                          child: Center(
                              child: Text(
                            '${doc['tableNumber']}',
                            style: Theme.of(context).textTheme.displayMedium,
                          )),
                        );
                      }).toList(),
                    );

                    if (selectedTable != null) {
                      log('message $selectedTable');
                      // Handle the selected table, e.g., update UI or state
                      context.read<Cart>().updateTable(
                          selectedTable['tableNumber'],
                          selectedTable['capacity']);

                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(width: 2)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TISCH AUSWÄHLEN',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(fontSize: 14),
                          ),
                          const Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, value, child) {
      return AppBar(
        automaticallyImplyLeading: false, // Remove the default back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                showTableDialoge();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      value.tableNumber,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Visibility(
                      visible: value.tableNumber != "",
                      child: Text(
                        "ca. 5min",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
