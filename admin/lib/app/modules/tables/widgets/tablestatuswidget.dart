import 'package:flutter/material.dart';

class TableStatusWidget extends StatelessWidget {
  const TableStatusWidget({
    super.key,
    required this.color,
    required this.status,
  });

  final Color color;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        CircleAvatar(backgroundColor: color, radius: 8),
        Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
