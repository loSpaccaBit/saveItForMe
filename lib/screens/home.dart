import 'package:flutter/material.dart';
import 'package:save_it_forme/services/dbHelper.dart';
import 'package:save_it_forme/themes/circularProgress.dart';
import 'package:save_it_forme/widgets/popUpAdd.dart';
import 'package:save_it_forme/models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<CategoryMark>>? _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _add();
  }

  Future<void> _loadBookmarks() async {
    final List<CategoryMark>? bookmarks = await DatabaseHelper.getAllCategory();
    setState(() {
      _bookmarksFuture = Future.value(bookmarks);
    });
  }

  Future<void> _add() async {
    CategoryMark mark = CategoryMark(id_category: 2, titolo: 'Dev');
    await DatabaseHelper.addCategory(mark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 70),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => MyPopup(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
