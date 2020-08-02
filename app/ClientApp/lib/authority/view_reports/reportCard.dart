import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget{
  final int reported_student_count;
  final String reported_items;
  final int estimated_student_count;
  final String estimated_items;

  ReportCard(this.reported_student_count, this.reported_items, this.estimated_student_count, this.estimated_items);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(bottom:10,left: 8,right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: ListTile(
        dense: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("10", style: TextStyle(fontSize: 15)),
            Text("Friday", style: TextStyle(fontSize: 15))
          ],
        ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('No. of students:'),
              Text('Reported: $reported_student_count , Actual: $estimated_student_count'),
              Text('Menu Served:'),
              Text('Reported: $reported_items, Actual: $estimated_items')
          ],
          ),
      ),
    );
  }

}