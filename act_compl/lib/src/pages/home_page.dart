import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Actividad')),
          DataColumn(label: Text('Periodo')),
          DataColumn(label: Text('Creditos')),
          DataColumn(label: Text('Horas')),
          DataColumn(label: Text('Acreditada')),

        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Pesas')),
            DataCell(Text('AGO-DIC/2016')),
            DataCell(Text('1')),
            DataCell(Text('20')),
            DataCell(Text('True')),
          ]),
        ],
      );
  }
}