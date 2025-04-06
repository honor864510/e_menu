import 'package:collection/collection.dart';
import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:e_menu/src/feature/menu/widget/meal_card.dart';
import 'package:flutter/material.dart';

/// {@template meals_screen}
/// MealsScreen widget.
/// {@endtemplate}
class MealsScreen extends StatefulWidget {
  /// {@macro meals_screen}
  const MealsScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late final MealMenuController mealMenuController;

  MealCategoryTable? _table;
  MealCategoryID? categoryID;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(_tabControllerListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mealMenuController.addListener(_mealControllerListener);
      await mealMenuController.refresh();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    mealMenuController = ControllerScope.of<MealMenuController>(context);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController
      ..removeListener(_tabControllerListener)
      ..dispose();

    mealMenuController.removeListener(_mealControllerListener);
  }

  void _tabControllerListener() {
    if (_table == null) return;

    final currentId = _table!.keys.elementAt(_tabController.index).id;

    categoryID ??= currentId;

    if (currentId != categoryID) {
      categoryID = currentId;
    }
  }

  void _mealControllerListener() {
    _table ??= mealMenuController.mealCategoryTable;

    if (_table != mealMenuController.mealCategoryTable && _table != null) {
      _table = mealMenuController.mealCategoryTable;

      _tabController
        ..removeListener(_tabControllerListener)
        ..dispose();

      _tabController = TabController(
        length: _table!.length,
        vsync: this,
        initialIndex: _table!.keys.toList().indexWhere((e) => e.id == categoryID).abs(),
      );
      _tabController.addListener(_tabControllerListener);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: mealMenuController,
    builder: (context, _) {
      final isLoading = mealMenuController.isLoading;
      final mealCategoryTable = mealMenuController.mealCategoryTable;
      final categories = mealCategoryTable.keys;

      if (isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (categories.isEmpty) {
        return const Scaffold(body: Center(child: Text('Something went wrong')));
      }

      return Scaffold(
        appBar: TabBar(controller: _tabController, tabs: categories.map<Widget>((e) => Text(e.name)).toList()),
        body: TabBarView(
          controller: _tabController,
          children:
              categories
                  .map<Widget>(
                    (category) => RefreshIndicator(
                      onRefresh: () async {
                        mealMenuController.refresh().ignore();
                      },
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: mealCategoryTable[category]?.length ?? 0,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) => MealCard(meal: mealCategoryTable[category]!.elementAt(index)),
                      ),
                    ),
                  )
                  .toList(),
        ),
      );
    },
  );
}
