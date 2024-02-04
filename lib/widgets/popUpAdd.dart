import 'package:flutter/material.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:save_it_forme/models/category.dart';
import 'package:save_it_forme/services/dbHelper.dart';

class MyPopup extends StatefulWidget {
  const MyPopup({Key? key, this.url, this.title, this.description})
      : super(key: key);
  final String? url;
  final String? title;
  final String? description;
  @override
  _MyPopupState createState() => _MyPopupState();
}

class _MyPopupState extends State<MyPopup> {
  final _formKey = GlobalKey<FormState>();
  bool _isBookmarkSaved = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  int? _selectedCategoryId;
  List<CategoryMark>? _categories;
  @override
  void initState() {
    super.initState();
    _loadCategories();
    _checkSaved();
  }

  Future<void> _loadCategories() async {
    List<CategoryMark>? categories = await DatabaseHelper.getAllCategory();
    if (categories != null && categories.isNotEmpty) {
      setState(() {
        _categories = categories;
        _selectedCategoryId = _categories![0].id_category;
      });
    }
  }

  Future<void> _addCategory(String categoryName) async {
    CategoryMark newCategory = CategoryMark(titolo: categoryName);

    int categoryId = await DatabaseHelper.addCategory(newCategory);

    print('Added Category with ID: $categoryId');

    _loadCategories();
  }

  void _checkSaved() {
    if (widget.url != null) {
      _linkController.text = widget.url!;
      _descriptionController.text = widget.description!;
    }
  }

  Future<void> _showCreateCategoryDialog() async {
    String? categoryNameInput; // Cambiato da 'String' a 'String?'

    categoryNameInput = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crea nuova categoria'),
          content: TextField(
            onChanged: (value) => categoryNameInput = value,
            decoration: InputDecoration(labelText: 'Nome categoria'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialogo senza salvare
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                if (categoryNameInput != null &&
                    categoryNameInput!.isNotEmpty) {
                  await _addCategory(categoryNameInput!);

                  // Chiudi il dialogo e restituisci il nome della nuova categoria
                  Navigator.pop(context);
                }
              },
              child: Text('Aggiungi'),
            ),
          ],
        );
      },
    );

    if (categoryNameInput != null && categoryNameInput!.isNotEmpty) {
      // Aggiorna la lista delle categorie e seleziona la nuova categoria
      _loadCategories();
      setState(() {
        _selectedCategoryId = _categories!
            .firstWhere(
              (category) => category.titolo == categoryNameInput,
              orElse: () => null!,
            )
            ?.id_category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          height: 500,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Titolo',
                    hintText: 'Titolo',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci Titolo';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    labelText: 'Link',
                    hintText: 'https://wwww.google.com/',
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        !RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$')
                            .hasMatch(value!)) {
                      return 'Inserisci un link valido';
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Descrizione',
                    hintText: 'Descrizione',
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  onChanged: (newValue) {
                    if (newValue != null && newValue == -1) {
                      // Il valore -1 indica l'opzione di creare una nuova categoria
                      _showCreateCategoryDialog();
                    } else {
                      setState(() {
                        _selectedCategoryId = newValue as int?;
                      });
                    }
                  },
                  items: [
                    ..._categories?.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id_category,
                            child: Text(category.titolo),
                          );
                        }).toList() ??
                        [],
                    DropdownMenuItem<int>(
                      value: -1,
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              color: Colors
                                  .blue), // Icona "+" per indicare la creazione
                          SizedBox(width: 8),
                          Text('Crea nuova categoria'),
                        ],
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                  ),
                  validator: (value) {
                    if (value == null || value == -1) {
                      return 'Seleziona una categoria o crea una nuova categoria';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      BookMark newBookmark = BookMark(
                        id_category: _selectedCategoryId!,
                        titolo: _titleController.text,
                        url: _linkController.text,
                        descrizione: _descriptionController.text,
                      );

                      int bookmarkId =
                          await DatabaseHelper.addBookMark(newBookmark);

                      print('Saved Bookmark with ID: $bookmarkId');

                      setState(() {
                        _isBookmarkSaved = true;
                      });
                      Navigator.of(context).pop(isBookmarkSaved());
                    }
                  },
                  child: Text(
                    'Salva',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    minimumSize: Size(double.maxFinite, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // funzione per gestire se e stato inserito un nuovo record
  // true verra refreshata la UI
  bool isBookmarkSaved() {
    return _isBookmarkSaved;
  }
}
