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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            //Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //const SizedBox(width: 8),

                Radio<bool>(
                  value: true,
                  groupValue: isSelected,
                  onChanged: onSelected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
