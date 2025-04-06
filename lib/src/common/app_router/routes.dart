import 'package:e_menu/src/feature/cart/cart_screen.dart';
import 'package:e_menu/src/feature/home/home_screen.dart';
import 'package:e_menu/src/feature/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

enum Routes with OctopusRoute {
  home('home', title: 'Home'),
  menu('menu', title: 'Menu'),
  cart('cart', title: 'Cart');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(BuildContext context, OctopusState state, OctopusNode node) => switch (this) {
    Routes.home => const HomeScreen(),
    Routes.menu => const MenuScreen(),
    Routes.cart => const CartScreen(),
  };
}
