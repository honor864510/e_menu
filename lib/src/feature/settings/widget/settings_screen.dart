import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/feature/menu/widget/meals_screen.dart';
import 'package:flutter/material.dart';

final List<Color> _defaultColors = [
  Colors.amber,
  Colors.lightBlue,
  Colors.green,
  Colors.purple,
  Colors.blueGrey,
  Colors.indigoAccent,
];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Dependencies.of(context).settingsController;

    return Scaffold(
      body: ListenableBuilder(
        listenable: settingsController,
        builder:
            (context, child) => ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ...[
                  const _TitleText(title: 'IP адрес'),
                  TextFormField(
                    onChanged: (value) => settingsController.updateSetting(directusUrl: value),
                    textInputAction: TextInputAction.next,
                  ),
                  const _TitleText(title: 'Наименование Организации'),
                  TextFormField(
                    onChanged: (value) => settingsController.updateSetting(name: value),
                    textInputAction: TextInputAction.next,
                  ),
                  const _TitleText(title: 'Процент за обслуживание'),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged:
                        (value) => settingsController.updateSetting(servicePercentage: double.tryParse(value) ?? 0.0),
                  ),
                  const _TitleText(title: 'Палитра цветов'),
                  Wrap(
                    children: [
                      for (final color in _defaultColors) ...[
                        InkWell(
                          onTap: () => settingsController.updateSetting(colorPalette: color),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      color == settingsController.settings.seedColor
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),
                ].expand((e) => [e, const SizedBox(height: 12)]),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await settingsController.saveSettings();
          if (context.mounted) {
            await Navigator.of(
              context,
            ).push(MaterialPageRoute<Page<Object>>(builder: (context) => const MealsScreen()));
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(title, style: TextTheme.of(context).titleLarge);
}
