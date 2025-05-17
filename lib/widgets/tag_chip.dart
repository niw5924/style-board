import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String text;

  const TagChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: 12,
        ),
      ),
    );
  }
}
