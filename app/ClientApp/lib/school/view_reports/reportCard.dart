import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final int student_count;
  final String for_date;

  ReportCard(this.student_count, this.for_date);

  @override
  Widget build(BuildContext context) {
    var onlyDate = DateFormat('d').format(DateTime.parse(for_date));
    var onlyDay = DateFormat('E').format(DateTime.parse(for_date));

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(bottom: 10, left: 8, right: 8),
      decoration: BoxDecoration(
          color: Color.fromRGBO(222, 222, 222, 1),
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        dense: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(onlyDate,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
            Text(onlyDay,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No. of students: $student_count',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
