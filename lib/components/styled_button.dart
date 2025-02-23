import 'package:flutter/material.dart';

enum Variants { primary, secondary, success, danger, warning, info }

enum Shapes { rounded, circle, none }

const double buttonHeight = 40;

class StyledButton extends StatelessWidget {
  StyledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = Variants.primary,
    this.shape = Shapes.rounded,
    this.isDisabled = false,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final void Function() onPressed;
  final Widget child;
  final Variants variant;
  final Shapes shape;

  final bool isDisabled;
  final bool isLoading;
  final bool fullWidth;

  final Map<Variants, Color> colors = {
    Variants.primary: Colors.blueAccent,
    Variants.secondary: Colors.grey,
    Variants.success: Colors.green,
    Variants.danger: Colors.red,
    Variants.warning: Colors.orange,
    Variants.info: Colors.blue,
  };

  final Map<Variants, Color> textColor = {
    Variants.primary: Colors.white,
    Variants.secondary: Colors.black,
    Variants.success: Colors.white,
    Variants.danger: Colors.white,
    Variants.warning: Colors.black,
    Variants.info: Colors.white,
  };

  final Map<Shapes, double> borderRadius = {
    Shapes.rounded: 8,
    Shapes.circle: 100,
    Shapes.none: 0,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      color: colors[variant],
      disabledColor: colors[variant]!.withValues(
        alpha: 0.8,
      ),
      textColor: textColor[variant],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius[shape]!),
      ),
      minWidth: fullWidth ? double.infinity : null,
      height: buttonHeight,
      child: isLoading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : child,
    );
  }
}
