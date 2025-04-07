import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/feature/cart/cart_screen.dart';
import 'package:e_menu/src/feature/menu/widget/meals_screen.dart';
import 'package:flutter/material.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mealMenuController = Dependencies.of(context).mealMenuController;

    return ControllerScope(controller: mealMenuController, child: _Screen());
  }
}

class _Screen extends StatefulWidget {
  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  int activeIdx = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: activeIdx, children: const [MealsScreen(), CartScreen()]),
    // body: AnimatedSwitcher(
    //   duration: const Duration(milliseconds: 400),
    //   child: () {
    //     switch (activeIdx) {
    //       case 0:
    //         return const MealsScreen();
    //       case 1:
    //         return const CartScreen();
    //     }
    //   }(),
    // ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: activeIdx,
      onTap:
          (value) => setState(() {
            activeIdx = value;
          }),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.fastfood_rounded), label: 'Меню'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_rounded), label: 'Корзина'),
      ],
    ),
  );
}
