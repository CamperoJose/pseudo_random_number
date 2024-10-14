import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

void downloadCSVWeb(List<Map<String, dynamic>> results, String fileName) {
  List<List<dynamic>> rows = [
    ['i', 'Yi', 'Operación', 'X1', 'Ri'],
    ...results.map((result) => [
      result['i'],
      result['yi'],
      result['operation'],
      result['x1'],
      result['ri']
    ])
  ];

  String csv = const ListToCsvConverter().convert(rows);
  final bytes = utf8.encode(csv);
  final base64Str = base64.encode(bytes);

  final anchor = html.AnchorElement(href: 'data:text/csv;base64,$base64Str')
    ..setAttribute('download', '$fileName.csv')
    ..click();
}

void downloadExcelWeb(List<Map<String, dynamic>> results, String fileName) {
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];

  sheet.appendRow(['i', 'Yi', 'Operación', 'X1', 'Ri']);
  for (var result in results) {
    sheet.appendRow([
      result['i'],
      result['yi'],
      result['operation'],
      result['x1'],
      result['ri']
    ]);
  }

  final bytes = excel.encode();
  final base64Str = base64.encode(bytes!);

  final anchor = html.AnchorElement(href: 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64Str')
    ..setAttribute('download', '$fileName.xlsx')
    ..click();
}
