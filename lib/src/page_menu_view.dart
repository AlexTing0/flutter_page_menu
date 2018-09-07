import 'package:flutter/widgets.dart';
import 'dart:async';

import 'page_menu_controller.dart';

class PageMenuView extends StatefulWidget {
  PageMenuView ({
    @required this.tabViews,
    @required this.pageMenuController,
  }):assert(tabViews != null && tabViews.length > 0);

  final List<Widget> tabViews;
  final PageMenuController pageMenuController;

  @override
  _PageMenuViewState createState() => new _PageMenuViewState();
}

final PageScrollPhysics kTabBarViewPhysics = new PageScrollPhysics(parent: const BouncingScrollPhysics());

class _PageMenuViewState extends State<PageMenuView> {

  PageController _pageController;
  int _selectedIndex;
  int _warpUnderwayCount;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      widget.pageMenuController.addListener(_handleTabControllerTick);
      _pageController = new PageController(initialPage: _selectedIndex ?? 0);
      _warpUnderwayCount = 0;
  }

  @override
  void dispose() {
      // TODO: implement dispose
      widget.pageMenuController.removeListener(_handleTabControllerTick);
      super.dispose();
  }

  void _handleTabControllerTick() {
    if (_warpUnderwayCount > 0)
      return; // This widget is driving the controller's animation.
    
    if (widget.pageMenuController.index != _selectedIndex) {
      _selectedIndex = widget.pageMenuController.index;
      _scrollToSelectedIndex();
    }
  }

  Future<Null> _scrollToSelectedIndex() async {
    if (!mounted)
      return new Future<Null>.value();

    if (_pageController.page == _selectedIndex.toDouble())
      return new Future<Null>.value();
    
    _warpUnderwayCount += 1;
    await _pageController.animateToPage(_selectedIndex, duration: kPageMenuTabBarScrollDuration, curve: Curves.ease);
    _warpUnderwayCount -= 1;
    return new Future<Null>.value();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0)
      return false;

    if (notification.depth != 0)
      return false;

    _warpUnderwayCount += 1;
    if (notification is ScrollUpdateNotification) {
      if ((_pageController.page - widget.pageMenuController.index).abs() > 0.5) {
        widget.pageMenuController.index = _pageController.page.round();
        _selectedIndex=widget.pageMenuController.index;
      }
    } else if (notification is ScrollEndNotification) {
      widget.pageMenuController.index = _pageController.page.round();
      _selectedIndex = widget.pageMenuController.index;
    }
    _warpUnderwayCount -= 1;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener(
      onNotification: _handleScrollNotification,
      child: new PageView(
        controller: _pageController,
        children: widget.tabViews,
        physics: kTabBarViewPhysics,
        pageSnapping: false,
      ),
    );
  }
}