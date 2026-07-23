import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String? highlight;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    this.highlight,
    this.style,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    if (highlight == null || highlight!.trim().isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    final String query = highlight!.trim();
    // إزالة التشكيل من كلمة البحث أولاً
    final String cleanQuery = query.replaceAll(RegExp(r'[\u064B-\u065F]'), '');

    if (cleanQuery.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    // تقسيم البحث إلى كلمات متفرقة
    final words = cleanQuery
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    // بناء تعبير نمطي (Regex) لكل كلمة بحيث يسمح بوجود تشكيل بين الحروف ويدعم التشكيلات العربية
    final regexPatterns = words
        .map((word) {
          final patternChars = word
              .split('')
              .map((char) {
                if (char == 'ا' || char == 'أ' || char == 'إ' || char == 'آ') {
                  return '[اأإآ]';
                }
                if (char == 'ه' || char == 'ة') return '[هة]';
                if (char == 'ي' || char == 'ى') return '[يى]';
                return RegExp.escape(char);
              })
              .join(r'[\u064B-\u065F]*');
          return '($patternChars[\\u064B-\\u065F]*)';
        })
        .join('|');

    final regex = RegExp(regexPatterns, caseSensitive: false);
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    final spans = <TextSpan>[];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style:
              highlightStyle ??
              TextStyle(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      );
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}
