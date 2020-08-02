import 'package:flutter/material.dart';

import 'reportCard.dart';

class ReportsItem extends StatefulWidget {

  List<dynamic> reports = new List<dynamic>();

  ReportsItem(this.reports);
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
    for(int i=0; i< widget.reports.length; i++){
      actualItems = widget.reports[i]["actual_items"].map((item)=>item['item']).toList();
      items.add(actualItems.toString());
      estimatedItems = widget.reports[i]["estimate_items"].map((item)=>item['item']).toList();
      items.add(actualItems.toString());
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
      child: Card(
        color: Color.fromRGBO(93, 99, 108, 1),
        margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Month",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  OutlineButton(
                    splashColor: Color.fromRGBO(97, 227, 236, 1),
                    textColor: Color.fromRGBO(97, 227, 236, 1),
                    color: Colors.white,
                    onPressed: () {

                    },
                    child: Text("Show More"),
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                ListView.builder(
              itemBuilder: (BuildContext ctxt, int index) {
                  //return new ReportCard(widget.reports[index]["student_count"],items[index],widget.reports[index]["estimate_student_count"],est_items[index]);
                  return new ReportCard(widget.reports[index]["actual_student_count"],'dosa',widget.reports[index]["estimate_student_count"],'');
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