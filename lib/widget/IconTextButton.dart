import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? textColor;
  final Color backgroundColor;
  final double? iconSize;
  final double? fontSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const IconTextButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}