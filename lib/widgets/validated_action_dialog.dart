import 'dart:async';
import 'package:flutter/material.dart';

class ValidatedActionDialog extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget content;
  final String confirmText;
  final Future<String?> Function() submitIfValid;
  final dynamic Function()? onSuccessResult;

  const ValidatedActionDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.submitIfValid,
    this.onSuccessResult,
  });

  @override
  State<ValidatedActionDialog> createState() => _ValidatedActionDialogState();
}

class _ValidatedActionDialogState extends State<ValidatedActionDialog> {
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final message = await widget.submitIfValid();
                    if (message != null) {
                      _showError(message);
                    } else {
                      final result = widget.onSuccessResult?.call() ?? true;
                      Navigator.pop(context, result);
                    }
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
