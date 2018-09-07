import 'package:flutter/widgets.dart';

import 'page_menu_bar.dart';
import 'page_menu_view.dart';
import 'page_menu_controller.dart';

export 'page_menu_controller.dart';

const TextStyle defaultSelectTabTextStyle = TextStyle(color: Color(0xffff9c00), fontSize: 16.0, fontWeight: FontWeight.bold);
const TextStyle defaultUnSelectTabTextStyle = TextStyle(color: Color(0xff000000), fontSize: 16.0);
const Color defaultIndicatorColor = Color(0xffff9c00);
const EdgeInsets defaultBarPadding = EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0);
const Color defaultBackgroundColor = Color(0xffffffff);

class PageMenu extends StatefulWidget {

  PageMenu({
    @required this.tabTitles,
    @required this.tabViews,
    this.backgroundColor = defaultBackgroundColor,
    this.selectedTabTextStyle = defaultSelectTabTextStyle,
    this.unSelectedTabTextStyle = defaultUnSelectTabTextStyle,
    this.indicatorColor = defaultIndicatorColor,
    this.barPadding = defaultBarPadding,
    this.barHeight = 42.0,
    this.controller,
  }):assert(tabTitles != null && tabTitles.length >0),
  assert(tabViews != null && tabViews.length > 0),
  assert(tabTitles.length == tabViews.length);

  final List<String> tabTitles;
  final List<Widget> tabViews;
  final Color backgroundColor;

  ///PageMenuBar Style
  final TextStyle selectedTabTextStyle;
  final TextStyle unSelectedTabTextStyle;
  final Color indicatorColor;
  final EdgeInsets barPadding;
  final double barHeight;
  final PageMenuController controller;

  @override
  _PageMenuState createState() {
      // TODO: implement createState
      return new _PageMenuState();
    }
}

class _PageMenuState extends State<PageMenu> with SingleTickerProviderStateMixin {
  PageMenuController _pageMenuController;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _pageMenuController = widget.controller != null ? widget.controller : new PageMenuController(length: widget.tabTitles.length, vsync: this);
    }

  @override
  Widget build(BuildContext context) {
      // TODO: implement build
      return Container(
        color: widget.backgroundColor,
        child: Column(
          children: <Widget>[
            PageMenuBar(
              tabTitles: widget.tabTitles,
              pageMenuController: _pageMenuController,
              selectedTabTextStyle: widget.selectedTabTextStyle,
              unSelectedTabTextStyle: widget.unSelectedTabTextStyle,
              indicatorColor: widget.indicatorColor,
              padding: widget.barPadding,
              height: widget.barHeight,
            ),
            Flexible(
              child: PageMenuView(
                tabViews: widget.tabViews,
                pageMenuController: _pageMenuController,
              ),
            )
          ],
        ),
      );
    }
}