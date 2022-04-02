import 'dart:math';

import 'package:flutter/material.dart';

class PageStates {
  final Route? previousPage;
  final Route currentPage;
  final Route? nextPage;

  const PageStates({
    required this.previousPage,
    required this.currentPage,
    required this.nextPage,
  });

  bool isFirstPage() => previousPage == null;

  bool isLastPage() => nextPage == null;
}

/// Let's say that your login flow requires the user to fill in their information and the form is split into 5 pages.
/// However, some of the information in those 5 pages can also be pre-obtained through other means, which would render
/// some of the pages in this flow unnecessary.
///
/// The solution would be to have a stacked navigator that we can just say push this set of pages in order.
///
/// In pages that are marked with the DynamicRouteParticipator mixin.
///
/// ```dart
///
///   StackedNavigator.loadStack([AddressPage, OccupationPage, XPage, XXPage]);
///
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
  static List<PageStates> _pageStates = [];
  static int _currentPageIndex = 0;
  static bool _isStackLoaded = false;

  StackedRoutesNavigator._();

  static List<Route> getCurrentRouteStack() {
    return _pageStates.map((e) => e.currentPage).toList();
  }

  static Route getCurrentRoute() {
    return _pageStates[_currentPageIndex].currentPage;
  }

  static clearStack() {
    _isStackLoaded = false;
    _pageStates = [];
  }

  static loadStack(List<Widget> pages) {
    _isStackLoaded = true;
    _pageStates = _generatePageStates(pages: pages);
  }

  static List<PageStates> _generatePageStates({required List<Widget> pages}) {
    final List<PageStates> pageStates = [];
    for (int i = 0; i < pages.length; i++) {
      final previousPage = i - 1 < 0 ? null : pages[i - 1];
      final nextPage = i + 1 >= pages.length ? null : pages[i + 1];
      final currentPage = pages[i];

      final currentPageStates = PageStates(
          previousPage: _generateRoute(previousPage),
          currentPage: _generateRoute(currentPage)!,
          nextPage: _generateRoute(nextPage));

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

    Navigator.of(context).push(currentPage.nextPage!);

    _currentPageIndex++;
  }

  /// Pop the current page from the stack
  static void popCurrent(BuildContext context) {
    assert(_isStackLoaded,
        "the loadStack() method should be called first before this can be used.");

    _currentPageIndex = max(0, _currentPageIndex - 1);

    Navigator.pop(context);
  }
}

mixin DynamicRouteParticipator {}
