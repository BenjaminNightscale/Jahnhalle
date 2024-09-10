import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/cart_page.dart';
import 'package:jahnhalle/pages/mohsim/checkout_screen.dart';
import 'package:provider/provider.dart';

class OrderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrderAppBar({super.key});

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
        // actions: [
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         mainAxisSize: MainAxisSize.min,
        //         children: <Widget>[
        //           Text(
        //             "Tisch 30",
        //             style: Theme.of(context)
        //                 .textTheme
        //                 .displayMedium
        //                 ?.copyWith(fontSize: 18),
        //           ),
        //           Text(
        //             "ca. 5min",
        //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        //                 color: Theme.of(context).colorScheme.secondary),
        //           ),
        //         ],
        //       ),
        //       SizedBox(
        //         width: dimensions.width * 0.05,
        //       )
        //       // Consumer<Cart>(
        //       //   builder: (context, cart, child) {
        //       //     int totalItems =
        //       //         cart.items.fold(0, (sum, item) => sum + item.quantity);
        //       //     return Stack(
        //       //       children: <Widget>[
        //       //         IconButton(
        //       //           icon: const Icon(Icons.shopping_cart_outlined),
        //       //           onPressed: () {
        //       //             Navigator.push(
        //       //               context,
        //       //               MaterialPageRoute(
        //       //                   builder: (context) => CheckoutScreen()),
        //       //             );
        //       //           },
        //       //         ),
        //       //         if (totalItems > 0)
        //       //           Positioned(
        //       //             right: 5,
        //       //             bottom: 5,
        //       //             child: Container(
        //       //               padding: const EdgeInsets.all(0),
        //       //               decoration: BoxDecoration(
        //       //                 color: Theme.of(context).colorScheme.onSurface,
        //       //                 borderRadius: BorderRadius.circular(10),
        //       //               ),
        //       //               constraints: const BoxConstraints(
        //       //                 minWidth: 16,
        //       //                 minHeight: 16,
        //       //               ),
        //       //               child: Text(
        //       //                 '$totalItems',
        //       //                 style: TextStyle(
        //       //                     color: Theme.of(context).colorScheme.surface,
        //       //                     fontSize: 12,
        //       //                     fontWeight: FontWeight.bold),
        //       //                 textAlign: TextAlign.center,
        //       //               ),
        //       //             ),
        //       //           ),
        //       //       ],
        //       //     );
        //       //   },
        //       // ),
        //     ],
        //   ),
        // ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
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
          ],
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
