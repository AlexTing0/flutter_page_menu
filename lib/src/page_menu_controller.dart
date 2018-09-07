import 'package:flutter/widgets.dart';

const kPageMenuTabBarScrollDuration = Duration(milliseconds: 300);

class PageMenuController extends ChangeNotifier{
  PageMenuController({@required this.length, @required TickerProvider vsync}):
  assert(length != null && length > 0),
  _index = 0;
  final int length;

  int get index => _index;
  int _index;
  set index(int value) {
    _changeIndex(value);
  }

  int get previousIndex => _previousIndex;
  int _previousIndex = 0;

  void _changeIndex(int value, { Duration duration, Curve curve }) {
    assert(value != null);
    assert(value >= 0 && (value < length || length == 0));
    assert(duration == null ? curve == null : true);
    if (value == _index || length < 2)
      return;
    _previousIndex = index;
    _index = value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}