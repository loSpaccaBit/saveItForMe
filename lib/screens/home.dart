import 'package:flutter/material.dart';
import 'package:save_it_forme/themes/circularProgress.dart';
import 'package:save_it_forme/widgets/popUpAdd.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text.rich(
                TextSpan(
                  text: 'Save It ',
                  style: Theme.of(context).textTheme.headline1,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'ForMe',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.white,
                            backgroundColor: Theme.of(context).hoverColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   child: Center(
          //     child: CircularIndicatorCustom(),
          //   ),
          // ),
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
