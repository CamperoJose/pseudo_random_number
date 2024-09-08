import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  CustomTable({required this.results});

  @override
  Widget build(BuildContext context) {
    return results.isEmpty
        ? Center(
            child: Text(
              'No se han generado números.',
              style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Color(0xFF232635)),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  columnSpacing: 30.0,
                  horizontalMargin: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  columns: [
                    DataColumn(
                      label: Text(
                        'i',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Xi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Ri',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                  rows: results.map((result) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              result['i'].toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              result['xi'].toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              result['ri'].toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
  }
}
