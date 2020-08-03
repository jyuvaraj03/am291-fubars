import 'package:ClientApp/authority/view_reports/reportDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final String schoolName;
  final bool discrepancy;
  final String date;
  final int reportedCount;
  final int estimatedCount;
  final String reportedMenu;
  final String estimatedMenu;

  ReportCard(this.schoolName, this.discrepancy, this.date, this.reportedCount,
      this.estimatedCount, this.reportedMenu, this.estimatedMenu);

  @override
  Widget build(BuildContext context) {
    var onlyDate = DateFormat('d').format(DateTime.parse(date));
    var onlyDay = DateFormat('E').format(DateTime.parse(date));
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Color.fromRGBO(222, 222, 222, 1),
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        dense: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ReportDetail(
                      schoolName,
                      date,
                      reportedCount,
                      estimatedCount,
                      reportedMenu,
                      estimatedMenu,
                      discrepancy)));
        },
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("$onlyDate",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            Text("$onlyDay",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '$schoolName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            //Text('Discrepancy: $discrepancy'),
          ],
        ),
        trailing: discrepancy
            ? Icon(
                Icons.report_problem,
                color: Colors.red,
              )
            : Icon(
                Icons.arrow_forward,
                color: Colors.green,
                size: 30,
              ),
      ),
    );
  }
}
