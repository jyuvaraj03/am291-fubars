import "package:flutter/material.dart";

class ReportDetail extends StatelessWidget {

  final String schoolName;
  final String date;
  final int reportedCount;
  final int estimatedCount;
  final String reportedMenu;
  final String estimatedMenu;
  
  ReportDetail(
    this.schoolName, 
    this.date, 
    this.reportedCount, 
    this.estimatedCount, 
    this.reportedMenu, 
    this.estimatedMenu
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        Text("School Name"),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Colors.yellow, borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: {
                  0: FractionColumnWidth(.4),
                  1: FractionColumnWidth(.6),
                },
                children: [
                  TableRow(children: [
                    Text("Name"),
                    Text('$schoolName'),
                  ]),
                  TableRow(children: [
                    Text("Location"),
                    Text('3/1, Lorem ipsum street, Lorem'),
                  ]),
                  TableRow(children: [
                    Text("Correspondent"),
                    Text('Vishal umachandar'),
                  ]),
                  TableRow(children: [
                    
                    Text("Contact"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('9876543210'),
                          Text('567356'),
                          Text('mvm@gmail.com'),
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
        Text("Report Details"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: Colors.yellow, borderRadius: BorderRadius.circular(15)),
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
                    Text("Date"),
                    Text('$date'),
                  ]),
                  TableRow(children: [
                    Text("Attendance"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reported: $reportedCount'),
                          Text('Estimated: $estimatedCount'),
                        ],
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Menu"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reported: $reportedMenu'),
                          Text('Estimated: $estimatedMenu'),
                        ],
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Text("Discrepancy"),
                    Text('No'),
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
