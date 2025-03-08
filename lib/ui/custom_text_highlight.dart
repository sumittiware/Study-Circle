import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// ✅ **Only using MarkdownElementBuilder**
class CustomTextHighlight extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    String textContent = text.text;

    // Check if the text contains the highlight pattern
    if (textContent.contains("!!")) {
      List<InlineSpan> spans = [];
      RegExp regex = RegExp(r'!!(.*?)!!');
      Iterable<RegExpMatch> matches = regex.allMatches(textContent);

      int lastMatchEnd = 0;
      for (var match in matches) {
        // Add normal text before match
        if (match.start > lastMatchEnd) {
          spans.add(
            TextSpan(
              text: textContent.substring(lastMatchEnd, match.start),
              style: preferredStyle,
            ),
          );
        }
        // Add highlighted text
        spans.add(
          WidgetSpan(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Color(0xff302A1F), // Highlight background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                match.group(1)!, // Extracted text
                style: TextStyle(
                  color: Color(0xffffab2e),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        lastMatchEnd = match.end;
      }

      // Add remaining normal text
      if (lastMatchEnd < textContent.length) {
        spans.add(
          TextSpan(
            text: textContent.substring(lastMatchEnd),
            style: preferredStyle,
          ),
        );
      }

      return RichText(text: TextSpan(children: spans));
    }

    return Text(textContent, style: preferredStyle);
  }
}
