import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const TypewriterText({
    required this.text,
    this.style,
    super.key,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _visibleText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while (mounted) {
      while (_currentIndex < widget.text.length) {
        await Future.delayed(const Duration(milliseconds: 120));
        setState(() {
          _visibleText += widget.text[_currentIndex];
          _currentIndex++;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _visibleText = '';
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_visibleText, style: widget.style);
  }
}
