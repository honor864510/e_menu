import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:e_menu/src/feature/menu/widget/meal_card.dart';
import 'package:flutter/material.dart';

/// {@template catalog_tab}
/// CatalogTab widget that displays categories as tabs and meals in a grid.
/// {@endtemplate}
class CatalogTab extends StatefulWidget {
  /// {@macro catalog_tab}
  const CatalogTab({super.key});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> with TickerProviderStateMixin {
  TabController? _tabController;
  late MealMenuController _menuController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _menuController = ControllerScope.of<MealMenuController>(context);
    _menuController.addListener(_onMenuStateChanged);

    // Initialize with 1 tab, will update when data is loaded
    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _menuController.removeListener(_onMenuStateChanged);
    super.dispose();
  }

  void _onMenuStateChanged() {
    if (!mounted) return;

    _initializeTabController();
  }

  void _initializeTabController() {
    final categories = _menuController.categories;
    if (categories.isEmpty) return;

    // Recreate tab controller with the correct number of tabs
    _tabController?.dispose();
    _tabController = TabController(length: categories.length, vsync: this);
    setState(() {});
  }

  Future<void> _fetchData() async {
    await _menuController.refresh();
    _initializeTabController();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of<MealMenuController>(context);
    final categories = _menuController.categories;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        if (controller.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (categories.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No categories available'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _menuController.fetch, child: const Text('Refresh')),
                ],
              ),
            ),
          );
        }

        return child!;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: categories.map(_buildCategoryTab).toList(),
          ),
        ),
        body: TabBarView(controller: _tabController, children: categories.map(_buildCategoryContent).toList()),
      ),
    );
  }

  Widget _buildCategoryTab(MealCategoryModel category) => Tab(
    key: ValueKey(category.id),
    text: category.name,
    icon:
        category.imageUrl != null && category.imageUrl!.isNotEmpty
            ? Image.network(
              category.imageUrl!,
              width: 24,
              height: 24,
              errorBuilder: (_, __, ___) => const Icon(Icons.restaurant),
            )
            : const Icon(Icons.restaurant),
  );

  Widget _buildCategoryContent(MealCategoryModel category) {
    final meals = _menuController.getMealsByCategory(category.id);

    if (meals.isEmpty) {
      return const Center(child: Text('No meals available in this category'));
    }

    return RefreshIndicator(
      key: ValueKey(meals),
      onRefresh: _fetchData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisExtent: 220,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) => MealCard(meal: meals[index]),
      ),
    );
  }
}
