import 'dart:math';

import 'package:flutter/cupertino.dart';
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
///   const routes = StackedNavigator(pages: [AddressPage, OccupationPage, XPage, XXPage]);
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
///   StackedNavigator.pushNext(context);
///   //or
///   StackedNavigator.popCurrent(context);
/// ```
///

//TODO also added a mechanism for passing information
//TODO clear stack
//TODO check for pages with the mixin only
// TODO detect through the passed props if we are doing things through StackedNavigator not just using Navigator directly.
// TODO tests
class StackedNavigator {
  List<PageStates> _pageStates = [];
  int _currentPageIndex = 0;

  StackedNavigator({
    required List<Widget> pages,
  }) {
    _pageStates = _generatePageStates(pages: pages);
  }

  List<Route> getCurrentPageStack() {
    return _pageStates.map((e) => e.currentPage).toList();
  }

  List<PageStates> _generatePageStates({required List<Widget> pages}) {
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

  Route? _generateRoute(Widget? page) {
    if (page == null) return null;

    return MaterialPageRoute(builder: (context) => page);
  }

  /// Push the next page in the stack
  void pushNext(BuildContext context) {
    final currentPage = _pageStates[_currentPageIndex];

    assert(
        !currentPage.isLastPage(),
        "There are no more pages to push. This is the end of the flow. "
        "From this page onward, use the Navigator class instead");

    Navigator.of(context).push(currentPage.nextPage!);

    _currentPageIndex++;
  }

  /// Pop the current page from the stack
  void popCurrent(BuildContext context) {
    _currentPageIndex = max(0, _currentPageIndex - 1);

    Navigator.pop(context);
  }
}

mixin DynamicRouteParticipator {}
