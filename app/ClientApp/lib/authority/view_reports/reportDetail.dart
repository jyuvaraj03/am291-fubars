import "package:flutter/material.dart";

class ReportDetail extends StatelessWidget {
  final String schoolName;
  final String date;
  final int reportedCount;
  final int estimatedCount;
  final String reportedMenu;
  final String estimatedMenu;
  final bool discrepancy;
  ReportDetail(this.schoolName, this.date, this.reportedCount,
      this.estimatedCount, this.reportedMenu, this.estimatedMenu, this.discrepancy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _reportDetails(),
            _schoolDetails(),
          ],
        ),
      ),
    );
  }

  Widget _schoolDetails() {
    double iconSize = 40;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
          child: Text(
            "School Details",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(50, 134, 103, 1)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Color.fromRGBO(222, 222, 222, 1),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FractionColumnWidth(.4),
                  1: FractionColumnWidth(.6),
                },
                children: [
                  TableRow(children: [
                    Text("Name",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$schoolName',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Location",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('3/1, Lorem ipsum street, Lorem',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Correspondent",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Vishal umachandar',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Contact",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('9876543210',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text('567356',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text('mvm@gmail.com',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _reportDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
          child: Text("Report Details",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(50, 134, 103, 1))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Color.fromRGBO(222, 222, 222, 1),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FractionColumnWidth(.4),
                  1: FractionColumnWidth(.6),
                },
                children: [
                  TableRow(children: [
                    Text("Date",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$date',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Attendance",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reported: $reportedCount',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text('Estimated: $estimatedCount',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Menu",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reported: $reportedMenu',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text('Estimated: $estimatedMenu',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Discrepancy",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(discrepancy?"Yes":"No",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
