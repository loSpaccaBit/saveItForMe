import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPopup extends StatefulWidget {
  @override
  _MyPopupState createState() => _MyPopupState();
}

class _MyPopupState extends State<MyPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Categoria 1'; // Valore predefinito

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titolo',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un titolo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Link',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                validator: (value) {
                  // Utilizza una regex per validare il formato del link
                  if (value!.isEmpty) {
                    return 'Inserisci un link';
                  } else if (!RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$')
                      .hasMatch(value)) {
                    return 'Inserisci un link valido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 5, // Imposta il numero desiderato di righe
                decoration: InputDecoration(
                  labelText: 'Descrizione',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedCategory,
                items: ['Categoria 1', 'Categoria 2', 'Categoria 3']
                    .map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Esegui azioni con i dati inseriti
                    print('Titolo: ${_titleController.text}');
                    print('Link: ${_linkController.text}');
                    print('Descrizione: ${_descriptionController.text}');
                    print('Categoria: $_selectedCategory');
                    Navigator.pop(context); // Chiudi il popup
                  }
                },
                child: Text('Salva'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
