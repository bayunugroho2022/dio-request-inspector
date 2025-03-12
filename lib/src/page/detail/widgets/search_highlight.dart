library search_text_highlight_plus;

import 'package:flutter/material.dart';

class SearchHighlightWidget extends TextEditingController {
  final ScrollController? scrollController;

  final Color selectedTextBackgroundColor;

  final TextStyle? normalTextStyle;

  final TextStyle? selectedHighlightedTextStyle;

  final TextStyle? highlightedTextStyle;

  final Color highlightTextBackgroundColor;

  final bool caseSensitive;

  int _currentIndex = -1;

  final ValueNotifier<List<HighlightSpanWidget>> _highlightsNotifier =
      ValueNotifier([]);

  ValueNotifier<List<HighlightSpanWidget>> get highlightsNotifier =>
      _highlightsNotifier;

  int get currentIndex => _currentIndex;

  int get totalHighlights => _highlightsNotifier.value.length;

  SearchHighlightWidget({
    super.text,
    this.scrollController,
    this.selectedTextBackgroundColor = Colors.orange,
    this.highlightTextBackgroundColor = Colors.yellow,
    this.selectedHighlightedTextStyle,
    this.highlightedTextStyle,
    this.normalTextStyle,
    this.caseSensitive = false,
  });

  void highlightSearchTerm(String searchTerm) {
    if (searchTerm.isEmpty) {
      _clearHighlights();
      _currentIndex = -1;
      return;
    }

    setHighlights(searchTerm: searchTerm, currentIndex: _currentIndex);

    if (_currentIndex == -1 && _highlightsNotifier.value.isNotEmpty) {
      _currentIndex = 0;
      _scrollToCurrent();
    }
  }

  void setHighlights({required String searchTerm, required int currentIndex}) {
    List<HighlightSpanWidget> newHighlights = [];
    String fullText = text;

    String pattern = RegExp.escape(searchTerm);
    List<RegExpMatch> matches = RegExp(pattern, caseSensitive: caseSensitive)
        .allMatches(fullText)
        .toList();

    for (int i = 0; i < matches.length; i++) {
      RegExpMatch match = matches[i];
      newHighlights.add(
        HighlightSpanWidget(
          start: match.start,
          end: match.end,
          color: i == currentIndex
              ? selectedTextBackgroundColor
              : highlightTextBackgroundColor,
          textStyle: i == currentIndex
              ? selectedHighlightedTextStyle
              : highlightedTextStyle,
        ),
      );
    }

    _highlightsNotifier.value = newHighlights;
  }

  void updateHighlightColor(int currentIndex) {
    List<HighlightSpanWidget> updatedHighlights = [];
    for (int i = 0; i < _highlightsNotifier.value.length; i++) {
      updatedHighlights.add(
        HighlightSpanWidget(
            start: _highlightsNotifier.value[i].start,
            end: _highlightsNotifier.value[i].end,
            color: i == currentIndex
                ? selectedTextBackgroundColor
                : highlightTextBackgroundColor,
            textStyle: i == currentIndex
                ? selectedHighlightedTextStyle
                : highlightedTextStyle),
      );
    }
    _highlightsNotifier.value = updatedHighlights;
  }

  void _scrollToCurrent() {
    if (scrollController == null) {
      return;
    }

    if (_currentIndex != -1 && _highlightsNotifier.value.isNotEmpty) {
      final index = _highlightsNotifier.value[_currentIndex].start;
      scrollController!.animateTo(
        (index / text.length) * scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void highlightNext() {
    if (_currentIndex < _highlightsNotifier.value.length - 1) {
      _currentIndex++;
      updateHighlightColor(_currentIndex);
      _scrollToCurrent();
    }
  }

  void highlightPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      updateHighlightColor(_currentIndex);
      _scrollToCurrent();
    }
  }

  void _clearHighlights() {
    _highlightsNotifier.value = [];
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> children = [];
    String fullText = value.text;
    List<HighlightSpanWidget> highlights = _highlightsNotifier.value;

    if (highlights.isEmpty) {
      children.add(TextSpan(text: fullText));
    } else {
      int lastMatchEnd = 0;
      for (HighlightSpanWidget highlight in highlights) {
        if (lastMatchEnd < highlight.start) {
          children.add(
            TextSpan(
              text: fullText.substring(
                lastMatchEnd,
                highlight.start,
              ),
              style: normalTextStyle,
            ),
          );
        }
        children.add(
          TextSpan(
            text: fullText.substring(highlight.start, highlight.end),
            style: highlight.textStyle
                    ?.copyWith(backgroundColor: highlight.color) ??
                TextStyle(backgroundColor: highlight.color),
          ),
        );
        lastMatchEnd = highlight.end;
      }
      if (lastMatchEnd < fullText.length) {
        children.add(
          TextSpan(
            text: fullText.substring(lastMatchEnd),
            style: normalTextStyle,
          ),
        );
      }
    }

    return TextSpan(style: style, children: children);
  }
}

class HighlightSpanWidget {
  final int start;
  final int end;
  final Color color;
  final TextStyle? textStyle;

  HighlightSpanWidget({
    required this.start,
    required this.end,
    required this.color,
    required this.textStyle,
  });

  @override
  String toString() {
    return 'HighlightSpanWidget{start: $start, end: $end, color: $color}';
  }
}
