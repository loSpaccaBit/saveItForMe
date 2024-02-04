import 'package:flutter/material.dart';
import 'package:save_it_forme/services/dbHelper.dart';
import 'package:save_it_forme/themes/circularProgress.dart';
import 'package:save_it_forme/widgets/popUpAdd.dart';
import 'package:save_it_forme/widgets/bookMarkCard.dart';
import 'package:save_it_forme/models/category.dart';
import 'package:save_it_forme/models/bookMark.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CategoryMark>? _categoryMarks = [];
  late List<BookMark>? _bookMarks = [];
  late int _countBookMark = -1;
  CategoryMark? _selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshUI();
  }

  Future<void> _loadCategory() async {
    final List<CategoryMark>? category = await DatabaseHelper.getAllCategory();
    print('Loading category: $category');
    setState(() {
      _categoryMarks = category;
    });
  }

  Future<void> _loadBookmarks() async {
    final List<BookMark>? bookmarks = await DatabaseHelper.getAllBookMark();
    print('Loading bookmarks: $bookmarks');
    print(_bookMarks);
    if (bookmarks != null) {
      setState(() {
        _bookMarks = bookmarks;
      });
    } else {
      setState(() {
        _bookMarks = [];
      });
    }
  }

  Future<void> _countAll() async {
    final int count = await DatabaseHelper.countAllBookMarkByCategory(
        CategoryMark(id_category: 2, titolo: 'Test'));
    setState(() {
      _countBookMark = count;
    });
  }

  Future<void> _refreshUI() async {
    try {
      print('Refreshing UI...');
      await _loadCategory();
      await _loadBookmarks();
      await _countAll();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error in _refreshUI: $e');
    }
  }

  Future<void> _showAddDialog() async {
    bool? bookmarkSaved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return MyPopup();
      },
    );

    if (bookmarkSaved == true) {
      await _refreshUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text.rich(
                  TextSpan(
                    text: 'Save It ',
                    style: Theme.of(context).textTheme.headline1,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'ForMe',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: 22,
                              color: Colors.white,
                              backgroundColor: Theme.of(context).hoverColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle settings button click
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<CategoryMark>(
                value: _selectedCategory,
                items: (_categoryMarks ?? []).asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;

                  return DropdownMenuItem<CategoryMark>(
                    value: category,
                    child: Text(category.titolo),
                  );
                }).toList(),
                onChanged: (CategoryMark? selectedCategory) {
                  setState(() {
                    // Find the selected category based on index
                    final index = (_categoryMarks ?? [])
                        .indexWhere((cat) => cat == selectedCategory);
                    if (index != -1) {
                      _selectedCategory = _categoryMarks![index];
                    }
                  });
                },
              ),
              Text(
                _selectedCategory != null
                    ? 'Book ${_countBookMark} - ${_selectedCategory!.titolo}'
                    : 'Book ${_countBookMark}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          (_bookMarks!.isEmpty || _bookMarks == null)
              ? Expanded(
                  child: Center(
                  child: Text(
                    'Nessuna nota 📝 trovata 💔',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ))
              : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      mainAxisSpacing: 8.0, 
                      crossAxisSpacing: 8.0, 
                    ),
                    itemCount: _bookMarks!.length,
                    itemBuilder: (context, index) {
                      return BookMarkCard(
                          bookMark: _bookMarks![index],
                          onDelete: (bool value) async {
                            if (value) {
                              await _refreshUI();
                            }
                          });
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
