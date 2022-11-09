import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.child, required this.onTap});
  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context)!;
    return ElevatedButton(
      onPressed: form.valid ? onTap : null,
      child: child,
    );
  }
}
