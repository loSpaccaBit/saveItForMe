import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_it_forme/widgets/popUpAdd.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:save_it_forme/models/bookMark.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';

class WebViewModule extends StatefulWidget {
  const WebViewModule({Key? key, required this.bookMark}) : super(key: key);
  final BookMark bookMark;

  @override
  State<WebViewModule> createState() => _WebViewModuleState();
}

enum _SelectedTab {
  arrow_left_circle,
  arrow_right_square,
  arrow_down_circle,
  bookmark,
  send
}

class _WebViewModuleState extends State<WebViewModule> {
  late final WebViewController _controller;
  var _selectedTab = _SelectedTab.arrow_left_circle;
  bool isOpened = false;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
    switch (i) {
      case 0:
        goBack();
        break;
      case 1:
        goForward();
        break;
      case 2:
        goRefresh();
        break;
      case 3:
        savePage();
        break;
      case 4:
        sharePage();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('${widget.bookMark.url}'));
  }

  // Function to go back in the web view
  Future<void> goBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    }
  }

  // Function to go forward in the web view
  Future<void> goForward() async {
    if (await _controller.canGoForward()) {
      _controller.goForward();
    }
  }

  Future<void> goRefresh() async {
    _controller.reload();
  }

  // Function to save the current page
  // Function to save the current page
  void savePage() async {
    dynamic currentUrl = await _controller.currentUrl();
    dynamic currentTitle = await _controller.getTitle();
    print(currentTitle);
    setState(() {
      isOpened = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyPopup(
          url: currentUrl,
          description: currentTitle,
        );
      },
    );
  }

  // Function to share the current page
  void sharePage() async {
    dynamic currentUrl = await _controller.currentUrl();
    Share.shareUri(Uri.parse(currentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: isOpened
          ? Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CrystalNavigationBar(
                currentIndex: _SelectedTab.values.indexOf(_selectedTab),
                // indicatorColor: Colors.white,
                unselectedItemColor: Colors.white70,
                backgroundColor: Colors.black.withOpacity(0.1),

                enableFloatingNavBar: true,
                // outlineBorderColor: Colors.black.withOpacity(0.1),
                onTap: _handleIndexChanged,
                items: [
                  /// Home
                  CrystalNavigationBarItem(
                    icon: IconlyBold.arrow_left_circle,
                    unselectedIcon: IconlyLight.arrow_left_circle,
                    selectedColor: Colors.white,
                  ),

                  /// Favourite
                  CrystalNavigationBarItem(
                    icon: IconlyBold.arrow_right_circle,
                    unselectedIcon: IconlyLight.arrow_right_circle,
                    selectedColor: Colors.white,
                  ),

                  /// Search
                  CrystalNavigationBarItem(
                      icon: IconlyBold.arrow_down_circle,
                      unselectedIcon: IconlyLight.arrow_down_circle,
                      selectedColor: Colors.green),

                  /// Add
                  CrystalNavigationBarItem(
                    icon: IconlyBold.bookmark,
                    unselectedIcon: IconlyLight.bookmark,
                    selectedColor: Colors.yellow,
                  ),

                  /// Profile
                  CrystalNavigationBarItem(
                    icon: IconlyBold.send,
                    unselectedIcon: IconlyLight.send,
                    selectedColor: Colors.blue,
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              isOpened = !isOpened;
            });
          },
          child:
              isOpened == false ? Icon(IconlyBold.show) : Icon(IconlyBold.hide),
        ),
      ),
    );
  }
}
