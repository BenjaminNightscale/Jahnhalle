import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/services/database/drink.dart';

class RenderProduct extends StatefulWidget {
  final Drink drink;
  final Cart cart;

  const RenderProduct({required this.drink, required this.cart, Key? key}) : super(key: key);

  @override
  _RenderProductState createState() => _RenderProductState();
}

class _RenderProductState extends State<RenderProduct> {
  bool isOptionsVisible = false;
  Timer? overlayTimer;

  void toggleOptions() {
    setState(() {
      isOptionsVisible = !isOptionsVisible;
    });

    _startOrResetTimer();
  }

  void _startOrResetTimer() {
    overlayTimer?.cancel();
    overlayTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isOptionsVisible = false;
        });
      }
    });
  }

  void increaseQuantity() {
    widget.cart.increaseQuantity(widget.drink);
    _startOrResetTimer();
    setState(() {});
  }

  void decreaseQuantity() {
    widget.cart.decreaseQuantity(widget.drink);
    _startOrResetTimer();
    setState(() {});
  }

  @override
  void dispose() {
    overlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var drink = widget.drink;

    return Slidable(
      key: ValueKey(drink.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              widget.cart.setQuantityToZero(drink);
              setState(() {
                isOptionsVisible = false;
              });
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: toggleOptions,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: isOptionsVisible ? 40 : 30, // Change height dynamically
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.tertiary),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${drink.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        if (!isOptionsVisible)
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drink.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        drink.ingredients.join(' , '),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(drink.price * drink.quantity).toStringAsFixed(2)}€',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: 10,
            left: isOptionsVisible ? 70 : -200, // Start off-screen when not visible
            child: Container(
              height: 40.0,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border.all(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.primary),
                    onPressed: decreaseQuantity,
                  ),
                  Container(
                    width: 1,
                    color: Theme.of(context).colorScheme.tertiary,
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                    onPressed: increaseQuantity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
