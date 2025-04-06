part of 'meal_menu_screen.dart';

/// {@template shop_tabs_enum}
/// MealMenuTabsEnum enumeration
/// {@endtemplate}
enum MealMenuTabsEnum implements Comparable<MealMenuTabsEnum> {
  /// Catalog
  catalog('catalog'),

  /// Basket
  basket('basket');

  /// {@macro shop_tabs_enum}
  const MealMenuTabsEnum(this.name);

  /// Creates a new instance of [MealMenuTabsEnum] from a given string.
  static MealMenuTabsEnum fromValue(String? value, {MealMenuTabsEnum? fallback}) => switch (value
      ?.trim()
      .toLowerCase()) {
    'catalog' => catalog,
    'basket' => basket,
    _ => fallback ?? (throw ArgumentError.value(value)),
  };

  /// Value of the enum
  final String name;

  /// Pattern matching
  T map<T>({required T Function() catalog, required T Function() basket, required T Function() favorites}) =>
      switch (this) {
        MealMenuTabsEnum.catalog => catalog(),
        MealMenuTabsEnum.basket => basket(),
      };

  /// Pattern matching
  T maybeMap<T>({required T Function() orElse, T Function()? catalog, T Function()? basket, T Function()? favorites}) =>
      map<T>(catalog: catalog ?? orElse, basket: basket ?? orElse, favorites: favorites ?? orElse);

  /// Pattern matching
  T? maybeMapOrNull<T>({T Function()? catalog, T Function()? basket, T Function()? favorites}) =>
      maybeMap<T?>(orElse: () => null, catalog: catalog, basket: basket, favorites: favorites);

  @override
  int compareTo(MealMenuTabsEnum other) => index.compareTo(other.index);

  @override
  String toString() => name;
}

class _MealMenuScreen extends StatefulWidget {
  @override
  State<_MealMenuScreen> createState() => _MealMenuScreenState();
}

class _MealMenuScreenState extends State<_MealMenuScreen> {
  // Octopus state observer
  late final OctopusStateObserver _octopusStateObserver;

  // Current tab
  MealMenuTabsEnum _tab = MealMenuTabsEnum.catalog;

  @override
  void initState() {
    super.initState();
    _octopusStateObserver = context.octopus.observer;

    // Restore tab from router arguments
    _tab = MealMenuTabsEnum.fromValue(
      _octopusStateObserver.value.arguments['meal_menu'],
      fallback: MealMenuTabsEnum.catalog,
    );
    _octopusStateObserver.addListener(_onOctopusStateChanged);
  }

  @override
  void dispose() {
    _octopusStateObserver.removeListener(_onOctopusStateChanged);
    super.dispose();
  }

  // Change tab
  void _switchTab(MealMenuTabsEnum tab) {
    if (!mounted) return;
    if (_tab == tab) return;
    context.octopus.setArguments((args) => args['meal_menu'] = tab.name);
    setState(() => _tab = tab);
  }

  // Pop to catalog at double tap on catalog tab
  void _clearCatalogNavigationStack() {
    context.octopus.setState((state) {
      final catalog = state.findByName('catalog-tab');
      if (catalog == null || catalog.children.length < 2) return state;
      catalog.children.length = 1;

      return state;
    });
  }

  // Bottom navigation bar item tapped
  void _onItemTapped(int index) {
    final newTab = MealMenuTabsEnum.values[index];
    if (_tab == newTab) {
      // The same tab tapped twice
      if (newTab == MealMenuTabsEnum.catalog) _clearCatalogNavigationStack();
    } else {
      // Switch tab to new one
      _switchTab(newTab);
    }
  }

  // Router state changed
  void _onOctopusStateChanged() {
    final newTab = MealMenuTabsEnum.fromValue(
      _octopusStateObserver.value.arguments['meal_menu'],
      fallback: MealMenuTabsEnum.catalog,
    );
    _switchTab(newTab);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    // Disable page transition animation
    body: NoAnimationScope(child: IndexedStack(index: _tab.index, children: const <Widget>[CatalogTab(), BasketTab()])),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.fastfood_rounded), label: 'Меню'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_rounded), label: 'Корзина'),
      ],
      currentIndex: _tab.index,
      onTap: _onItemTapped,
    ),
  );
}
