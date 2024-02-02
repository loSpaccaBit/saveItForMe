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
  Future<List<CategoryMark>>? _bookmarksFuture;
  Future<List<BookMark>>? _bookMarks;

  @override
  void initState() {
    super.initState();
    _refreshUI();
  }

  Future<void> _loadCategory() async {
    final List<CategoryMark>? bookmarks = await DatabaseHelper.getAllCategory();
    setState(() {
      _bookmarksFuture = Future.value(bookmarks);
    });
  }

  Future<void> _loadBookmarks() async {
    final List<BookMark>? bookmarks = await DatabaseHelper.getAllBookMark();
    setState(() {
      _bookMarks = Future.value(bookmarks);
    });
  }

  Future<void> _refreshUI() async {
    await _loadCategory();
    await _loadBookmarks();
  }

  Future<void> _showAddDialog() async {
    bool? bookmarkSaved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return MyPopup();
      },
    );

    if (bookmarkSaved == true) {
      await _loadBookmarks();
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
          FutureBuilder<List<CategoryMark>>(
            future: _bookmarksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularIndicatorCustom();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No bookmarks available.');
              } else {
                CategoryMark data = snapshot.data![0];
                return Container(
                  child: Center(
                    child: Text(
                      '${data.titolo}',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 25),
                    ),
                  ),
                );
              }
            },
          ),
          FutureBuilder<List<BookMark>>(
            future: _bookMarks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularIndicatorCustom();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Text('No bookmarks available.');
              } else {
                // Accedi ai dati come lista di BookMark
                List<BookMark> bookmarks = snapshot.data!;
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                    ),
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      return BookMarkCard(
                        bookMark: bookmarks[index],
                        onDelete: (bool values) async {
                          if (values == true) {
                            await _refreshUI();
                          }
                        },
                      );
                    },
                  ),
                );
              }
            },
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
