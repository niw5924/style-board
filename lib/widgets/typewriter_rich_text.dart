import 'package:flutter/material.dart';

class TypewriterRichText extends StatefulWidget {
  final List<TextSpan> spans;

  const TypewriterRichText({
    required this.spans,
    super.key,
  });

  @override
  State<TypewriterRichText> createState() => _TypewriterRichTextState();
}

class _TypewriterRichTextState extends State<TypewriterRichText> {
  late final List<_CharSpan> _charSpans;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _charSpans = _flattenSpans(widget.spans);
    _startTyping();
  }

  void _startTyping() async {
    while (mounted) {
      while (_currentIndex < _charSpans.length) {
        await Future.delayed(const Duration(milliseconds: 150));
        if (!mounted) return;
        setState(() {
          _currentIndex++;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  List<_CharSpan> _flattenSpans(List<TextSpan> spans) {
    final List<_CharSpan> result = [];
    for (final span in spans) {
      final text = span.text ?? '';
      for (int i = 0; i < text.length; i++) {
        result.add(_CharSpan(
          text[i],
          span.style,
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: _charSpans
            .take(_currentIndex)
            .map((charSpan) =>
                TextSpan(text: charSpan.char, style: charSpan.style))
            .toList(),
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CharSpan {
  final String char;
  final TextStyle? style;

  _CharSpan(this.char, this.style);
}
