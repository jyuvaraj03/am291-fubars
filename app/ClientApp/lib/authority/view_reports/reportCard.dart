import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget{
  //final int student_count;
  //final String items;

  //ReportCard(this.student_count,this.items);

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
            Text("10"),
            Text("Friday")
          ],
        ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('No. of students: '),
              Text('Menu Served: '),
          ],
          ),
      ),
    );
  }

}