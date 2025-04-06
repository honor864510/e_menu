part of 'home_screen.dart';

class _Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.fastfood_rounded), label: 'Меню'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: 'Корзина'),
      ],
    ),
  );
}
