import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jahnhalle/pages/mohsim/model/order_detail_model.dart';
import 'package:jahnhalle/pages/mohsim/order_overview.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart with ChangeNotifier {
  final List<Drink> _items = [];
  double _tipPercentage = 15.0;

  List<Drink> get items => _items;
  double get tipPercentage => _tipPercentage;

  void addItem(Drink drink) {
    var existingItem = _items.firstWhere((item) => item.id == drink.id,
        orElse: () => Drink(
              id: drink.id,
              name: drink.name,
              category: drink.category,
              price: drink.price,
              imageUrl: drink.imageUrl,
              ingredients: drink.ingredients,
              quantity: 0,
            ));

    if (existingItem.quantity == 0) {
      _items.add(existingItem);
    }

    existingItem.quantity++;
    _reserveDrink(drink);
    notifyListeners();
  }

  void removeItem(Drink drink) {
    _items.removeWhere((item) => item.id == drink.id);
    _releaseDrink(drink);
    notifyListeners();
  }

  double get totalPrice {
    return subtotal * (1 + _tipPercentage / 100);
  }

  double get subtotal {
    return _items.fold(
        0.0, (total, current) => total + current.price * current.quantity);
  }

  void setTipPercentage(double percentage) {
    if (_tipPercentage == percentage) {
      _tipPercentage = 0.0;
    } else {
      _tipPercentage = percentage;
    }
    notifyListeners();
  }

  void clear() {
    for (var drink in _items) {
      _releaseDrink(drink);
    }
    _items.clear();
    _tipPercentage = 0.0;
    notifyListeners();
  }

  void increaseQuantity(Drink drink) {
    drink.quantity++;
    _reserveDrink(drink);
    notifyListeners();
  }

  void decreaseQuantity(Drink drink) {
    if (drink.quantity > 1) {
      drink.quantity--;
    } else {
      _items.remove(drink);
    }
    _releaseDrink(drink);
    notifyListeners();
  }

  void setQuantityToZero(Drink drink) {
    drink.quantity = 0;
    _items.remove(drink);
    _releaseDrink(drink);
    notifyListeners();
  }

  void _reserveDrink(Drink drink) {
    FirebaseFirestore.instance
        .collection('drinks')
        .doc(drink.id)
        .update({'quantity': FieldValue.increment(-1)});
  }

  void _releaseDrink(Drink drink) {
    FirebaseFirestore.instance
        .collection('drinks')
        .doc(drink.id)
        .update({'quantity': FieldValue.increment(1)});
  }

  void finalizeOrder() {
    _items.clear();
    notifyListeners();
  }

  String _tableNumber = "";
  String get tableNumber => _tableNumber;
  String _tableCapacity = "";
  String get tableCapacity => _tableCapacity;

  void updateTable(String value, String capacity) {
    _tableNumber = value;
    _tableCapacity = capacity;
    log('tableCapacity $tableCapacity');
    log('tableNumber $tableNumber');
    notifyListeners();
  }

  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  Future<int> _getNextOrderId() async {
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference counterRef = FirebaseFirestore.instance
          .collection('counters')
          .doc('order_counter');
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

      int currentOrderId =
          counterSnapshot.exists ? counterSnapshot.get('currentOrderId') : 0;
      int nextOrderId = currentOrderId + 1;

      transaction.set(counterRef, {'currentOrderId': nextOrderId});
      return nextOrderId;
    });
  }

  Future<void> addOrder(BuildContext context) async {
    try {
      int orderId = await _getNextOrderId();
      Map<String, dynamic> tableData = {
        "capacity": tableCapacity,
        "tableNumber": tableNumber
      };
      // Convert the list of Drink objects to a list of maps
      List<Map<String, dynamic>> itemMaps =
          items.map((drink) => drink.toMap()).toList();

      // Add the order to Firestore with the generated order ID
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId.toString())
          .set({
        'orderId': orderId,
        'orderStatus': "wartend",
        'status': "Bestellung angenommen",
        'paymentMethod': "cashPayment",
        'table': tableData,
        'items': itemMaps,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'deliveredAt': FieldValue.serverTimestamp(),
      });
      finalizeOrder();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderOverviewScreen(
              orderID: orderId,
            ),
          ));
      log('Order added successfully with ID $orderId!');
    } catch (e) {
      log('Failed to add order: $e');
    }
  }

  Stream<OrderDetail?> streamOrderDetails(int orderId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId.toString())
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        // Convert the document data to your Order model
        return OrderDetail.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        print('Document does not exist');
        return null;
      }
    }).handleError((error) {
      print('Error streaming order details: $error');
      return null;
    });
  }
}
