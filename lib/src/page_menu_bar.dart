import 'package:flutter/widgets.dart';

import 'page_menu_controller.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({
    this.text,
    this.textStyle, 
  });

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Container(
        child: Text(
          text,
          style: textStyle,
        ),
      );
    } else {
      return new Container();
    }
  }
}

class PageMenuBar extends StatefulWidget {
  PageMenuBar({
    @required this.tabTitles, 
    this.selectedTabTextStyle,
    this.unSelectedTabTextStyle,
    this.indicatorColor,
    @required this.pageMenuController,
    this.padding,
    this.height,
    }):assert(tabTitles != null && tabTitles.length > 0);
  
  final List<String> tabTitles;
  final TextStyle selectedTabTextStyle;
  final TextStyle unSelectedTabTextStyle;
  final Color indicatorColor;
  final EdgeInsets padding;
  final double height;
  final PageMenuController pageMenuController;

  @override
  _PageMenuBarState createState() => new _PageMenuBarState();
}

class _PageMenuBarState extends State<PageMenuBar> {

  int _selectIndex;
  int _preIndex;
  List<double> _tabWidths;
  List<double> _tabOriginX;
  double _spaceWidth = 0.0;
  double _screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _selectIndex = 0;
    _preIndex = 0;
    widget.pageMenuController.addListener(_handleTabControllerTick);
    _tabWidths = new List<double>(widget.tabTitles.length);
    _tabOriginX = new List<double>(widget.tabTitles.length);

    //calculate tab width
    for (int i = 0; i < widget.tabTitles.length; ++i) {
      TextSpan textSpan = new TextSpan(text: widget.tabTitles[i], style: widget.selectedTabTextStyle);
      TextPainter textPainter = new TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      _tabWidths[i] = textPainter.width;
    }
  }

  @override
  void dispose() {
    widget.pageMenuController.removeListener(_handleTabControllerTick);
    super.dispose();
  }

  void _handleTabControllerTick() {
    if (widget.pageMenuController.index == _selectIndex) {
      return;
    }

    _selectIndex = widget.pageMenuController.index;
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabTitles.length);
    //widget.pageMenuController.animateTo(index);
    widget.pageMenuController.index = index;
    print('_handleTap');
  }

  @override
  Widget build(BuildContext context) {
    _calculateSpaceWidthIfNeed();
    double beginOriginX = _tabOriginX[_preIndex];
    double endOriginX = _tabOriginX[_selectIndex];
    double beginWidth = _tabWidths[_preIndex];
    double endWidth = _tabWidths[_selectIndex];
    _preIndex = _selectIndex;

    List<Widget> tabWidgets = new List<Widget>(widget.tabTitles.length);
    for (int i = 0; i < widget.tabTitles.length; ++i) {
      tabWidgets[i] = new GestureDetector(
        child: MenuBar(
          text: widget.tabTitles[i],
          textStyle: i == _selectIndex ? widget.selectedTabTextStyle : widget.unSelectedTabTextStyle,
        ),
        onTap: (){_handleTap(i);},
      );
    }

    return new Container(
      height: widget.height,
      padding: widget.padding,
      //color: Color(0xff123456),
      child: new Column(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: tabWidgets,
              ),
            ),
          ),
          Container(
            height: 10.0,
            child: new PageMenuBarIndicator(
              beginOriginX: beginOriginX,
              endOriginX: endOriginX,
              beginWidth: beginWidth,
              endWidth: endWidth,
              height: 2.0,
              indicatorColor: widget.indicatorColor,
            ),
          ),
        ],
      ),
    );
  }

  void _calculateSpaceWidthIfNeed() {
    double screenWidth = MediaQuery.of(context).size.width;
    if (_screenWidth == screenWidth) {
      return;
    }
    _screenWidth = screenWidth;
    print('screenWidth:$screenWidth');
    screenWidth = screenWidth - widget.padding.left - widget.padding.right;
    for (int i = 0; i < _tabWidths.length; ++i) {
      screenWidth = screenWidth - _tabWidths[i];
    }

    _spaceWidth = screenWidth / (widget.tabTitles.length + 1);
    double currentOriginX = 0.0;

    for (int i = 0; i < _tabWidths.length; ++i) {
      currentOriginX = currentOriginX + _spaceWidth;
      _tabOriginX[i] = currentOriginX;
      currentOriginX += _tabWidths[i];
    }
  }
}

class PageMenuBarIndicator extends StatefulWidget {
  PageMenuBarIndicator({this.height, this.beginOriginX, this.endOriginX, this.beginWidth, this.endWidth, this.indicatorColor});

  final double height;
  final double beginOriginX;
  final double endOriginX;
  final double beginWidth;
  final double endWidth;
  final Color  indicatorColor;
  @override
  State<StatefulWidget> createState() {
      // TODO: implement createState
      return new _PageMenuBarIndicatorState();
    }

}

class _PageMenuBarIndicatorState extends State<PageMenuBarIndicator> with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
    }
  
  @override
  void didUpdateWidget(PageMenuBarIndicator oldWidget) {
      // TODO: implement didUpdateWidget
      super.didUpdateWidget(oldWidget);
      if(widget.beginOriginX != widget.endOriginX || widget.beginWidth != widget.endWidth) {
        if(_controller != null) {
          _controller.dispose();
        }
        _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)..addListener(() {
          setState(() {
          // the state that has changed here is the animation object’s value
          });
        });
        _controller.forward();
      }
    }

  @override
  void dispose() {
      // TODO: implement dispose
      _controller.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
      // TODO: implement build
      return Stack(
        children: <Widget>[
          Container(
          ),

          Positioned(
            left: widget.beginOriginX != widget.endOriginX ? (widget.endOriginX - widget.beginOriginX) * _animation.value + widget.beginOriginX: widget.beginOriginX,
            bottom: 0.0,
            height: widget.height,
            width: widget.beginWidth != widget.endWidth ? (widget.endWidth - widget.beginWidth) * _animation.value + widget.beginWidth: widget.beginWidth,
            child: Container(color: widget.indicatorColor,),
          )
        ],
      );
    }
}


