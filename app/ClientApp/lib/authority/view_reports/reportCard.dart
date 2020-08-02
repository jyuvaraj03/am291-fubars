import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget{
  final String schoolName;
  final bool discrepancy;
  final String date;
  
  ReportCard(this.schoolName, this.discrepancy, this.date);

  @override
  Widget build(BuildContext context) {
    var onlyDate = DateFormat('d').format(DateTime.parse(date));
    var onlyDay = DateFormat('E').format(DateTime.parse(date));
    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(bottom:10,left: 8,right: 8),
      decoration: BoxDecoration(
        color: discrepancy ? Colors.yellow : Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: ListTile(
        dense: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("$onlyDate", style: TextStyle(fontSize: 15)),
            Text("$onlyDay", style: TextStyle(fontSize: 12)),
          ],
        ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('School Name: $schoolName'),
              //Text('Discrepancy: $discrepancy'),
          ],
          ),
      ),
    );
  }

}