import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/components/footer/footer.dart';
import 'package:jahnhalle/components/drink_item.dart';
import 'package:jahnhalle/components/order_app_bar.dart';
import 'package:jahnhalle/pages/cart_page.dart';
import 'package:jahnhalle/pages/mohsim/checkout_screen.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:jahnhalle/services/database/firestore.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(),
      body: const DrinkMenu(),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return cart.items.isNotEmpty
            ? Footer(
                buttonText: 'Weiter',
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class DrinkMenu extends StatefulWidget {
  const DrinkMenu({super.key});

  @override
  _DrinkMenuState createState() => _DrinkMenuState();
}

class _DrinkMenuState extends State<DrinkMenu> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController categoryScrollController = ItemScrollController();

  late Map<String, List<Drink>> categorizedDrinks;
  late List<String> categories;
  late List<Widget> listWidgets;
  late Map<String, int> categoryIndexMap;
  String? selectedCategory;

  bool isLoading = true;
  String errorMessage = '';

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    loadDrinksFromFirestore();
  }

  void loadDrinksFromFirestore() {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    _firestoreService.streamDrinks().listen((drinks) {
      if (drinks.isEmpty) {
        print('No drinks found.');
        setState(() {
          isLoading = false;
          errorMessage = 'No drinks found.';
        });
      } else {
        print('Drinks received: $drinks'); // Debug print
        setState(() {
          _categorizeDrinks(drinks);
          buildListWidgets();
          itemPositionsListener.itemPositions
              .addListener(updateVisibleCategory);
          isLoading = false;
        });
        printCategories(); // Kategorien nach dem Herunterladen ausgeben
      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading drinks: $error';
      });
      print('Error loading drinks: $error');
    });
  }

  void _categorizeDrinks(List<Drink> drinks) {
    categorizedDrinks = {};
    for (var drink in drinks) {
      categorizedDrinks.putIfAbsent(drink.category, () => []).add(drink);
    }
    categories = categorizedDrinks.keys.toList();
    _sortCategories();
    categoryIndexMap = {};
  }

  void _sortCategories() {
    categories.sort((a, b) {
      if (a == 'Sparkombis') {
        return -1; // 'Sparkombis' should come first
      } else if (b == 'Sparkombis') {
        return 1; // 'Sparkombis' should come first
      } else {
        return a.compareTo(b); // Sort the rest alphabetically
      }
    });
  }

  void buildListWidgets() {
    int index = 0;
    listWidgets = [];

    for (var category in categories) {
      categoryIndexMap[category] = index;

      EdgeInsets categoryPadding = index == 0
          ? const EdgeInsets.only(
              top: 5.0, bottom: 15.0, left: 15.0, right: 15.0)
          : const EdgeInsets.only(
              top: 40.0, bottom: 15.0, left: 15.0, right: 15.0);

      listWidgets.add(
        Padding(
          padding: categoryPadding,
          child: Text(
            category,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      );
      index++;
      for (var drink in categorizedDrinks[category]!) {
        listWidgets.add(DrinkItem(drink: drink));
        index++;
      }
    }
  }

  void scrollToCategory(String category) {
    if (categoryIndexMap.containsKey(category)) {
      double customAlignment = (categoryIndexMap[category] == 0) ? 0.0 : -0.1;
      itemScrollController.scrollTo(
        index: categoryIndexMap[category]!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: customAlignment,
      );
      categoryScrollController.scrollTo(
        index: categories.indexOf(category),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void updateVisibleCategory() {
    var visiblePositions = itemPositionsListener.itemPositions.value;
    if (visiblePositions.isNotEmpty) {
      var firstVisiblePositions = visiblePositions.where((position) =>
          position.itemLeadingEdge <= 0 && position.itemTrailingEdge > 0);
      if (firstVisiblePositions.isNotEmpty) {
        int firstVisibleIndex = firstVisiblePositions
            .reduce((min, position) =>
                position.itemLeadingEdge > min.itemLeadingEdge ? position : min)
            .index;
        String? newCategory;
        Widget firstVisibleWidget = listWidgets[firstVisibleIndex];
        if (firstVisibleWidget is Padding) {
          Text? textWidget = firstVisibleWidget.child as Text?;
          if (textWidget != null) {
            newCategory = textWidget.data;
          }
        }
        if (newCategory != null && selectedCategory != newCategory) {
          setState(() {
            selectedCategory = newCategory;
          });
          categoryScrollController.scrollTo(
            index: categories.indexOf(newCategory),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.0,
          );
        }
      }
    }
  }

  void printCategories() {
    print("Downloaded categories: $categories");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Padding(
          padding: EdgeInsets.only(bottom: cart.items.isNotEmpty ? 85.0 : 30.0),
          child: Column(
            children: [
              _buildCategorySelector(),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: listWidgets.length,
                  itemBuilder: (context, index) => listWidgets[index],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
      ),
      child: ScrollablePositionedList.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemScrollController: categoryScrollController,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index];
          return Stack(
            children: [
              InkWell(
                onTap: () {
                  scrollToCategory(categories[index]);
                  setState(() => selectedCategory = categories[index]);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    categories[index],
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
