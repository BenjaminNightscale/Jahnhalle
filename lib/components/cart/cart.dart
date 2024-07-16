import 'package:flutter/foundation.dart';
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
}
