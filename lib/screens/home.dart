import 'package:flutter/material.dart';
import 'package:save_it_forme/screens/settings.dart';
import 'package:save_it_forme/services/dbHelper.dart';
import 'package:save_it_forme/themes/circularProgress.dart';
import 'package:save_it_forme/widgets/popUpAdd.dart';
import 'package:save_it_forme/widgets/bookMarkCard.dart';
import 'package:save_it_forme/models/category.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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
      _selectedCategory = category![0];
    });
  }

  // Future<void> _loadBookmarks() async {
  //   final List<BookMark>? bookmarks = await DatabaseHelper.getAllBookMark();
  //   print('Loading bookmarks: $bookmarks');
  //   print(_bookMarks);
  //   if (bookmarks != null) {
  //     setState(() {
  //       _bookMarks = bookmarks;
  //     });
  //   } else {
  //     setState(() {
  //       _bookMarks = [];
  //     });
  //   }
  // }

  Future<void> _loadBookmarks(CategoryMark categoryMark) async {
    final List<BookMark>? bookmarks =
        await DatabaseHelper.getAllBookMarkByCategory(categoryMark);
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

  Future<void> _countAll(CategoryMark categoryMark) async {
    final int count =
        await DatabaseHelper.countAllBookMarkByCategory(categoryMark);
    setState(() {
      _countBookMark = count;
    });
  }

  Future<void> _refreshUI() async {
    try {
      print('Refreshing UI...');
      await _loadCategory();
      await _loadBookmarks(_selectedCategory!);
      await _countAll(_selectedCategory!);
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
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await _refreshUI();
        },
        showChildOpacityTransition: false,
        height: 140,
        child: Column(
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
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Center(
              child: DropdownButton<CategoryMark>(
                value: _selectedCategory,
                items: _categoryMarks!.map((categoryMark) {
                  return DropdownMenuItem<CategoryMark>(
                    value: categoryMark,
                    child: Text(categoryMark.titolo),
                  );
                }).toList(),
                style: Theme.of(context).textTheme.headline1,
                borderRadius: BorderRadius.circular(20),
                onChanged: (value) async {
                  setState(() {
                    _selectedCategory = value;
                  });
                  await _loadBookmarks(_selectedCategory!);
                  await _countAll(_selectedCategory!);
                },
              ),
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
