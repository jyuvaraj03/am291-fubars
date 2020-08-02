import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget{
  final String schoolName;
  final String discrepancy;
  final String date;
  
  ReportCard(this.schoolName, this.discrepancy, this.date);


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
            Text("$date", style: TextStyle(fontSize: 15)),
          ],
        ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('School Name: $schoolName'),
              Text('Discrepancy: $discrepancy'),
          ],
          ),
      ),
    );
  }

}