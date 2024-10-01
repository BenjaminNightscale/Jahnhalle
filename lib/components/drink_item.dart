import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/services/database/cart.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/order/order_page.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:jahnhalle/components/themes/colors.dart';
import 'package:provider/provider.dart';

class DrinkItem extends StatefulWidget {
  final Drink drink;

  const DrinkItem({required this.drink, super.key});

  @override
  State<DrinkItem> createState() => _DrinkItemState();
}

class _DrinkItemState extends State<DrinkItem> {
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
    bool isOutOfStock = widget.drink.quantity <= 0;

    return InkWell(
      onTap: () {
        if (context.read<Cart>().tableNumber == "") {
          Future.microtask(() => showTableDialoge());
        } else {
          if (!isOutOfStock) {
            Provider.of<Cart>(context, listen: false).addItem(widget.drink);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: isOutOfStock
              ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.drink.name.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: isOutOfStock
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                    ),
                    const SizedBox(height: 8.0), // Add vertical space
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: widget.drink.ingredients.map((ingredient) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ingredient,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isOutOfStock
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                  ),
                            ),
                            if (ingredient != widget.drink.ingredients.last)
                              Text(
                                ',',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isOutOfStock
                                          ? Colors.grey
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8.0), // Add vertical space
                    Text(
                      '${widget.drink.price.toStringAsFixed(2)} €',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: isOutOfStock
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                    if (isOutOfStock)
                      const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isOutOfStock ? Colors.grey : Colors.black,
                    width: 2.0,
                  ),
                  color: isOutOfStock
                      ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 20, // Adjust the size as needed
                    color: isOutOfStock
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
