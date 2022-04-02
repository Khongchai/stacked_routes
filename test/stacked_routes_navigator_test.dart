import 'package:dynamic_routing/pages/page1.dart';
import 'package:dynamic_routing/pages/page2.dart';
import 'package:dynamic_routing/pages/page5.dart';
import 'package:dynamic_routing/stacked_routes/stacked_navigator.dart';
import "package:test/test.dart";

import '../lib/pages/page3.dart';

void main() {
  test("Navigator load test", () {
    final pageStack1 = [
      const Page1(),
      const Page2(),
      const Page3(),
      const Page5(),
    ];
    final pageStack2 = [
      const Page1(),
      const Page3(),
      const Page5(),
    ];
    final pageStack3 = [
      const Page5(),
    ];

    final routes1 = StackedRoutesNavigator.loadStack(pageStack1);
    expect(routes1.length, pageStack1.length);

    final routes2 = StackedRoutesNavigator.loadStack(pageStack2);
    expect(routes2.length, pageStack2.length);

    final routes3 = StackedRoutesNavigator.loadStack(pageStack3);
    expect(routes3.length, pageStack3.length);
  });

  group("Navigation test", () {
    final pageStack = [
      const Page1(),
      const Page2(),
      const Page3(),
      const Page5(),
    ];

    setUp(() {
      StackedRoutesNavigator.loadStack(pageStack);
    });
    tearDown(() {
      StackedRoutesNavigator.clearStack();
    });

    test("Current route increments and decrements correctly", () {
      //TODO needs a mock context for this, maybe go the widget tester way so that you can learn about it too.
      // StackedRoutesNavigator.pushNext(context);
    });
  });
}
