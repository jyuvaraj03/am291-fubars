import 'package:flutter/material.dart';

import 'reportCard.dart';

class ReportsItem extends StatefulWidget {
  List<dynamic> reports = new List<dynamic>();
  final String currentItemSelected;
  ReportsItem(this.reports, this.currentItemSelected);
  @override
  _ReportsItemState createState() => _ReportsItemState();
}

class _ReportsItemState extends State<ReportsItem> {
  List<dynamic> actualItems = new List<dynamic>();
  List<dynamic> estimatedItems = new List<dynamic>();
  List<String> items = [];
  List<String> est_items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //responsedata.map((json) => json['item']).toList()
    print(widget.reports.length);
    for (int i = 0; i < widget.reports.length; i++) {
      actualItems = widget.reports[i]["actual"]["items"]
          .map((item) => item['item'])
          .toList();
      items.add(actualItems.toString());
      estimatedItems = widget.reports[i]["estimate"]["items"]
          .map((item) => item['item'])
          .toList();
      print(estimatedItems);
      est_items.add(estimatedItems.toString());
      print(est_items);
    }
    print(items);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //open the Month reports page with all days of a selected month
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        // color: Color.fromRGBO(92, 92, 92, 1),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.currentItemSelected, // month dynamically
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(50, 134, 103, 1),
                      ),
                    ),
                  ),
                  // OutlineButton(
                  //   splashColor: Color.fromRGBO(97, 227, 236, 1),
                  //   textColor: Color.fromRGBO(97, 227, 236, 1),
                  //   color: Colors.white,
                  //   onPressed: () {},
                  //   child: Text("Show More"),
                  // )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                ListView.builder(
                  itemBuilder: (BuildContext ctxt, int index) {
                    //return new ReportCard(widget.reports[index]["student_count"],items[index],widget.reports[index]["estimate_student_count"],est_items[index]);
                    //return new ReportCard(widget.reports[index]["school"]["name"],true, widget.reports[index]["for_date"],widget.reports[index]["student_count"],widget.reports[index]["estimate_student_count"],items[index],est_items[index]);
                    return new ReportCard(
                        widget.reports[index]["school"]["name"],
                        true,
                        widget.reports[index]["for_date"],
                        widget.reports[index]["actual"]["student_count"],
                        widget.reports[index]["estimate"]["student_count"],
                        items[index],
                        est_items[index]);
                  },
                  itemCount: widget.reports.length,
                  shrinkWrap: true,
                )
              ],
            )
            //ReportCard(widget.reports[0]["actual_student_count"],items[0],widget.reports[0]["estimate_student_count"],est_items),
          ],
        ),
      ),
    );
  }
}
