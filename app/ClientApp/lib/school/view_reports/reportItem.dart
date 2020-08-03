import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'reportCard.dart';

class ReportsItem extends StatefulWidget {
  List<dynamic> reports = new List<dynamic>();
  final String month;
  ReportsItem(this.reports, this.month);

  @override
  _ReportsItemState createState() => _ReportsItemState();
}

class _ReportsItemState extends State<ReportsItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //open the Month reports page with all days of a selected month
      },
      child: Container(
        //color: Color.fromRGBO(93, 99, 108, 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.month,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(50, 134, 103, 1)),
                    ),
                  ),
                  // OutlineButton(
                  //   splashColor: Color.fromRGBO(97, 227, 236, 1),
                  //   textColor: Color.fromRGBO(97, 227, 236, 1),
                  //   color: Colors.white,
                  //   onPressed: () {},
                  //   child: Text("Show More"),
                  //)
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                itemBuilder: (BuildContext ctxt, int index) {
                  //return new ReportCard(widget.reports[index]["student_count"],items[index],widget.reports[index]["estimate_student_count"],est_items[index]);
                  return new ReportCard(widget.reports[index]["student_count"],
                      widget.reports[index]["for_date"]);
                },
                itemCount: widget.reports.length,
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
