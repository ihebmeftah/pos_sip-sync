import 'package:flutter/material.dart';
import '../../../data/model/enums/table_status.dart';
import '../../../data/model/table/tables.dart' as t;

class TableItemWidget extends StatelessWidget {
  const TableItemWidget({super.key, required this.table, required this.onTap});
  final t.Table table;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    ({int top, int left, int right, int bottom}) seats;
    seats = getSeatsSepration(table);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor:
          (table.status == TableStatus.occupied
                  ? Colors.red
                  : Colors.greenAccent)
              .withValues(alpha: 0.5),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            //* Left Seats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: List.generate(seats.left, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  color: table.status == TableStatus.occupied
                      ? Colors.red
                      : Colors.greenAccent,
                );
              }),
            ),
            Row(
              spacing: 8,
              children: [
                //* Top Seats
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: List.generate(seats.top, (index) {
                    return Container(
                      width: 10,
                      height: 10,
                      color: table.status == TableStatus.occupied
                          ? Colors.red
                          : Colors.greenAccent,
                    );
                  }),
                ),
                //* Main Table Container
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: table.status == TableStatus.occupied
                          ? Colors.red.shade700
                          : Colors.greenAccent.shade700,
                      border: Border.all(
                        color: table.status == TableStatus.occupied
                            ? Colors.red.shade400
                            : Colors.greenAccent.shade400,

                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          table.name.split('.').first,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Max seats ${table.seatsMax}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade50,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //* Bottom Seats
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: List.generate(seats.bottom, (index) {
                    return Container(
                      width: 10,
                      height: 10,
                      color: table.status == TableStatus.occupied
                          ? Colors.red
                          : Colors.greenAccent,
                    );
                  }),
                ),
              ],
            ),
            //* Right Seats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: List.generate(seats.right, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  color: table.status == TableStatus.occupied
                      ? Colors.red
                      : Colors.greenAccent,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

({int top, int left, int right, int bottom}) getSeatsSepration(t.Table table) {
  int seats = table.seatsMax;
  int top = 0, left = 0, right = 0, bottom = 0;
  List<int> sides = [0, 0, 0, 0]; // [top, right, bottom, left]
  for (int i = 0; i < seats; i++) {
    sides[i % 4]++;
  }
  top = sides[0];
  right = sides[1];
  bottom = sides[2];
  left = sides[3];
  return (top: top, right: right, bottom: bottom, left: left);
}
