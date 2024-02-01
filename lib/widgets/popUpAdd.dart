import 'package:flutter/material.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:save_it_forme/models/category.dart';
import 'package:save_it_forme/services/dbHelper.dart';

class MyPopup extends StatefulWidget {
  @override
  _MyPopupState createState() => _MyPopupState();
}

class _MyPopupState extends State<MyPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  int? _selectedCategoryId;
  List<CategoryMark>? _categories;

  @override
  void initState() {
    super.initState();
    _loadCategories();
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
                ),
                validator: (value) {
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
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Descrizione',
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<int>(
                    value: _selectedCategoryId,
                    items: _categories!.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id_category,
                        child: Text(
                          category.titolo,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Show a dialog to input a new category name
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Nuova Categoria'),
                            content: TextField(
                              controller: _categoryController,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                hintText: 'Categoria',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Annulla'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add the new category
                                  String categoryName =
                                      _categoryController.text;

                                  _addCategory(categoryName);
                                  Navigator.pop(context);
                                },
                                child: Text('Aggiungi'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create a BookMark object with the form data
                    BookMark newBookmark = BookMark(
                      id_category: _selectedCategoryId!,
                      titolo: _titleController.text,
                      url: _linkController.text,
                      descrizione: _descriptionController.text,
                    );

                    // Add the new bookmark to the database
                    int bookmarkId =
                        await DatabaseHelper.addBookMark(newBookmark);

                    // Print or handle the saved bookmark as needed
                    print('Saved Bookmark with ID: $bookmarkId');

                    // Close the popup
                    Navigator.pop(context);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
