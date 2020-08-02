import "package:flutter/material.dart";

class ReportDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _schoolDetails(),
            _reportDetails(),
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
                    Text('MVM'),
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
                    Text('2020-08-04'),
                  ]),
                  TableRow(children: [
                    Text("Attendance"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reported: 25'),
                          Text('Estimated: 20'),
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
                          Text('Reported: [idli, sambar, egg]'),
                          Text('Estimated: [idli, sambar]'),
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
