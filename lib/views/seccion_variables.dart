import 'package:flutter/material.dart';

class SeccionVariables extends StatelessWidget {
  final int diasDelMes;
  final int vidaUtilPasteles;
  final int diasEntregaProveedor;
  final double precioPastelPequeno;
  final double precioPastelMediano;
  final double precioPastelGrande;
  final Map<String, List<Map<String, dynamic>>> costosAdquisicion;

  SeccionVariables({
    required this.diasDelMes,
    required this.vidaUtilPasteles,
    required this.diasEntregaProveedor,
    required this.precioPastelPequeno,
    required this.precioPastelMediano,
    required this.precioPastelGrande,
    required this.costosAdquisicion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo('Variables Constantes'),
            _listaVariables(),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        texto,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800),
      ),
    );
  }

  Widget _listaVariables() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoVariable(
                      'Días del Mes', '${diasDelMes.toString()} días'),
                  _infoVariable(
                      'Vida Útil de los Pasteles', '$vidaUtilPasteles días'),
                  _infoVariable('Días de Entrega del Proveedor',
                      '$diasEntregaProveedor días'),
                  _infoVariable('Precio de Venta Pastel Pequeño',
                      '$precioPastelPequeno Bs'),
                  _infoVariable('Precio de Venta Pastel Mediano',
                      '$precioPastelMediano Bs'),
                  _infoVariable('Precio de Venta Pastel Grande',
                      '$precioPastelGrande Bs'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoCostosAdquisicion(
                      'Costos Pastel Pequeño', costosAdquisicion['pequeno']!),
                  _infoCostosAdquisicion(
                      'Costos Pastel Mediano', costosAdquisicion['mediano']!),
                  _infoCostosAdquisicion(
                      'Costos Pastel Grande', costosAdquisicion['grande']!),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoVariable(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(etiqueta,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          ),
          Expanded(
            flex: 1,
            child: Text(valor,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _infoCostosAdquisicion(
      String tipo, List<Map<String, dynamic>> costos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tipo,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade700)),
        ...costos.map((costo) {
          return Text(
            '${costo['rango']}: ${costo['precio']} Bs',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          );
        }).toList(),
      ],
    );
  }
}
