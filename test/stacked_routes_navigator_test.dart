import 'package:dynamic_routing/pages/page1.dart';
import 'package:dynamic_routing/pages/page2.dart';
import 'package:dynamic_routing/pages/page3.dart';
import 'package:dynamic_routing/pages/page4.dart';
import 'package:dynamic_routing/pages/page5.dart';
import 'package:dynamic_routing/stacked_routes/stacked_navigator.dart';
import 'package:flutter/material.dart';
import "package:flutter_test/flutter_test.dart";

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

    StackedRoutesNavigator.loadStack(pageStack1);
    expect(StackedRoutesNavigator.getCurrentRouteStack().length,
        pageStack1.length);

    StackedRoutesNavigator.loadStack(pageStack2);
    expect(StackedRoutesNavigator.getCurrentRouteStack().length,
        pageStack2.length);

    StackedRoutesNavigator.loadStack(pageStack3);
    expect(StackedRoutesNavigator.getCurrentRouteStack().length,
        pageStack3.length);
  });

  group("Navigation test", () {
    final pageStack = [
      const Page1(),
      const Page2(),
      const Page3(),
      const Page4(),
    ];

    Future<void> stubWidgetAndPerformNavigationTest(
        WidgetTester tester, Function(BuildContext context) doStuff) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          doStuff(context);
          return Container();
        }),
      ));
    }

    setUp(() {
      StackedRoutesNavigator.loadStack(pageStack);
    });
    tearDown(() {
      StackedRoutesNavigator.clearStack();
    });

    testWidgets("Current route increments and decrements correctly",
        (WidgetTester tester) async {
      stubWidgetAndPerformNavigationTest(tester, (context) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          StackedRoutesNavigator.pushFirst(context); // Page1();
          StackedRoutesNavigator.pushNext(context); // Page2();
          StackedRoutesNavigator.pushNext(context); // Page3();
          StackedRoutesNavigator.pushNext(context); // Page4();

          expect(StackedRoutesNavigator.getCurrentRouteWidget(),
              pageStack.last); // Page4()
        });
      });
    });
  });
}
