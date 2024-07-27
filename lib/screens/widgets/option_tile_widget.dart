import 'package:flutter/material.dart';

class OptionTileWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  OptionTileWidget({
    required this.text,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              text,
            ),
            const Spacer(),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: onSelected,
            ),
          ],
        ),
      ),
    );
  }
}
