import 'dart:async';
import 'package:flutter/material.dart';

class CommonPopupLayout extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final Future<String?> Function() onConfirm;

  const CommonPopupLayout({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<CommonPopupLayout> createState() => _CommonPopupLayoutState();
}

class _CommonPopupLayoutState extends State<CommonPopupLayout> {
  String? errorMessage;
  Timer? _errorTimer;

  void _showError(String message) {
    setState(() => errorMessage = message);
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => errorMessage = null);
    });
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    size: 24, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 8),
                Text(widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 24),
            widget.content,
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: errorMessage != null ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                errorMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: widget.onCancel, child: Text(widget.cancelText)),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final message = await widget.onConfirm();
                    if (message != null) _showError(message);
                  },
                  child: Text(widget.confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
