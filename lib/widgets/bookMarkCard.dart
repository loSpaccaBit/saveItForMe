import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:save_it_forme/services/dbHelper.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BookMarkCard extends StatefulWidget {
  const BookMarkCard({
    Key? key,
    required this.bookMark,
    required this.onDelete,
  }) : super(key: key);

  final BookMark bookMark;
  final Function(bool) onDelete;

  @override
  State<BookMarkCard> createState() => _BookMarkCardState();
}

class _BookMarkCardState extends State<BookMarkCard> {
  bool _deleted = false;
  final ChromeSafariBrowser browser = new ChromeSafariBrowser();

  bool isDeleted() {
    return _deleted;
  }

  @override
  void initState() {
    browser.addMenuItem(new ChromeSafariBrowserMenuItem(
        id: 1,
        label: 'Custom item menu 1',
        action: (url, title) {
          print('Custom item menu 1 clicked!');
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minWidth: 100, minHeight: 100, maxWidth: 150, maxHeight: 250),
      child: GestureDetector(
        onTap: () async {
          await browser.open(
              url: Uri.parse("${widget.bookMark.url}"),
              options: ChromeSafariBrowserClassOptions(
                  android: AndroidChromeCustomTabsOptions(
                      shareState: CustomTabsShareState.SHARE_STATE_OFF,
                      isTrustedWebActivity: true),
                  ios: IOSSafariOptions(
                      barCollapsingEnabled: true,
                      entersReaderIfAvailable: true)));
        },
        child: Card(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Posiziona la Column in basso
            children: [
              ListTile(
                title: AutoSizeText(
                  '${widget.bookMark.titolo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineLarge,
                  minFontSize: 18,
                ),
                subtitle: AutoSizeText(
                  '${widget.bookMark.descrizione}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                  minFontSize: 14,
                ),
                enableFeedback: true,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment:
              //       MainAxisAlignment.center, // Posiziona la Row a destra
              //   children: [
              //     Spacer(), // Aggiunto Spacer per spingere gli IconButton a destra
              //     IconButton(
              //       onPressed: () {
              //         print('Edit');
              //       },
              //       icon: Icon(Icons.edit_note),
              //       iconSize: 20,
              //       style: Theme.of(context).iconButtonTheme.style!.copyWith(
              //         backgroundColor: MaterialStateColor.resolveWith((states) {
              //           return Colors.green; // Default color
              //         }),
              //       ),
              //     ),
              Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  onPressed: () async {
                    print(
                        'BookMark Eliminato!\nID : ${widget.bookMark.id_bookMark}');
                    await DatabaseHelper.deleteBookMark(widget.bookMark);
                    setState(() {
                      _deleted = true;
                    });
                    return widget.onDelete(isDeleted());
                    //_deleted = _deleted;
                  },
                  icon: Icon(Icons.delete_forever),
                  style: Theme.of(context).iconButtonTheme.style!.copyWith(
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                      return Colors.orange; // Default color
                    }),
                  ),
                ),
              ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
