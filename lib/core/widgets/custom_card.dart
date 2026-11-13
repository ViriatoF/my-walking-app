import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? AppTheme.themeData.colorScheme.primary,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
