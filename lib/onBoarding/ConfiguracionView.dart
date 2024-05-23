import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/ThemeNotifier.dart';


class ConfiguracionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Tema oscuro'),
            value: themeNotifier.value.brightness == Brightness.dark,
            onChanged: (bool value) {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
