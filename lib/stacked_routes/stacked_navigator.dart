import 'dart:math';

import 'package:flutter/material.dart';

class PageRoutes {
  final Route? previousRoute;

  final Route currentRoute;

  /// The widget for the page assigned to the current route
  final Widget currentRouteWidget;

  final Route? nextRoute;

  const PageRoutes({
    required this.previousRoute,
    required this.currentRoute,
    required this.currentRouteWidget,
    required this.nextRoute,
  });

  bool isFirstPage() => previousRoute == null;

  bool isLastPage() => nextRoute == null;
}

/// Let's say that your login flow requires the user to fill in their information and the form is split into 5 pages.
/// However, some of the information in those 5 pages can also be pre-obtained through other means, which would render
/// some of the pages in this flow unnecessary.
///
/// The solution would be to have a stacked navigator that we can just say push this set of pages in order.
///
/// In pages that are marked with the DynamicRouteParticipator mixin.
///
/// Somewhere in the page right before AddressPage
///
/// ```dart
///   StackedNavigator.loadStack([AddressPage, OccupationPage, XPage, XXPage]);
///   StackedNavigator.pushFirst(context);
///```
///
/// Somewhere in AddressPage
/// ```dart
///   StackedNavigator.pushNext(context);
/// ```
///
/// Somewhere in OccupationPage
/// ```dart
///   StackedRoutesNavigator.pushNext(context);
///   //or
///   StackedRoutesNavigator.popCurrent(context);
/// ```
///

//TODO also added a mechanism for passing information
//TODO check for pages with the mixin only
// TODO detect through the passed props if we are doing things through StackedRoutesNavigator not just using Navigator directly.
// TODO annotation for @isStackLoadedRequired
// TODO tests
class StackedRoutesNavigator {
  static List<PageRoutes> _pageStates = [];
  static int _currentPageIndex = -1;
  static bool _isStackLoaded = false;

  StackedRoutesNavigator._();

  static List<Route> getCurrentRouteStack() {
    return _pageStates.map((e) => e.currentRoute).toList();
  }

  static Route getCurrentRoute() {
    return _pageStates[_currentPageIndex].currentRoute;
  }

  /// Returns the page widget that belongs to the current route
  static Widget getCurrentRouteWidget() {
    return _pageStates[_currentPageIndex].currentRouteWidget;
  }

  static clearStack() {
    _isStackLoaded = false;
    _pageStates = [];
    _currentPageIndex = -1;
  }

  static loadStack(List<Widget> pages) {
    _isStackLoaded = true;
    _pageStates = _generatePageStates(pages: pages);
  }

  static List<PageRoutes> _generatePageStates({required List<Widget> pages}) {
    final List<PageRoutes> pageStates = [];
    for (int i = 0; i < pages.length; i++) {
      final previousPage = i - 1 < 0 ? null : pages[i - 1];
      final nextPage = i + 1 >= pages.length ? null : pages[i + 1];
      final currentPage = pages[i];

      final currentPageStates = PageRoutes(
          previousRoute: _generateRoute(previousPage),
          currentRouteWidget: currentPage,
          currentRoute: _generateRoute(currentPage)!,
          nextRoute: _generateRoute(nextPage));

      pageStates.add(currentPageStates);
    }

    return pageStates;
  }

  static Route? _generateRoute(Widget? page) {
    if (page == null) return null;

    return MaterialPageRoute(builder: (context) => page);
  }

  /// Push the next page in the stack
  static void pushNext(BuildContext context) {
    final currentPage = _pageStates[_currentPageIndex];

    assert(
        !currentPage.isLastPage(),
        "There are no more pages to push. This is the end of the flow. "
        "From this page onward, use the Navigator class instead");
    assert(_isStackLoaded,
        "the loadStack() method should be called first before this can be used.");
    assert(_currentPageIndex != -1,
        "Call pushFirst(context) before the first page of this flow to begin stacked navigation");

    Navigator.of(context).push(currentPage.nextRoute!);

    _currentPageIndex++;
  }

  static void pushFirst(BuildContext context) {
    assert(_isStackLoaded,
        "the loadStack() method should be called first before this can be used.");

    _currentPageIndex = 0;
    Navigator.of(context).push(_pageStates.first.currentRoute);
  }

  /// Pop the current page from the stack
  static void popCurrent(BuildContext context) {
    assert(_isStackLoaded,
        "the loadStack() method should be called first before this can be used.");
    assert(_currentPageIndex != -1,
        "Call pushFirst(context) before the first page of this flow to begin stacked navigation");

    _currentPageIndex = max(0, _currentPageIndex - 1);

    Navigator.pop(context);
  }
}

mixin DynamicRouteParticipator {}
