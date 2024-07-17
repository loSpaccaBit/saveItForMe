import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:save_it_forme/services/dbHelper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.callbackAction})
      : super(key: key);
  final Future<void> callbackAction;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚙️ Impostazioni'),
        titleTextStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontSize: 25,
              color: Colors.white,
            ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      print('Importa');
                      DatabaseHelper.pickFile();
                      await widget.callbackAction;
                    },
                    icon: Icon(IconlyBold.download),
                    label: Text('Importa')),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      print('Esporta');
                      await DatabaseHelper.exportAllDB();
                      await widget.callbackAction;
                    },
                    icon: Icon(IconlyBold.upload),
                    label: Text('Esporta')),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '@2024 Francesco Pio Nocerino',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
