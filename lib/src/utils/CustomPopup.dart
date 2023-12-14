import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomPopUp {
  static void mostrarDialogoAgregarPago(
      BuildContext context,
      String apartmentId,
      String tenantName,
      Function(double monto, DateTime fecha) onAgregarPago) {
    final TextEditingController montoController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Pago'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un monto';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fechaController,
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? fecha = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (fecha != null) {
                      fechaController.text =
                          DateFormat('yyyy-MM-dd').format(fecha);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una fecha';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  double monto = double.parse(montoController.text);
                  DateTime fecha =
                      DateFormat('yyyy-MM-dd').parse(fechaController.text);
                  onAgregarPago(monto, fecha);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void mostrarDialogoAgregarGasto(
      BuildContext context,
      String apartmentId,
      Function(double monto, DateTime fecha, String descripcion)
          onAgregarGasto) {
    final TextEditingController montoController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Gasto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un monto';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fechaController,
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? fecha = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (fecha != null) {
                      fechaController.text =
                          DateFormat('yyyy-MM-dd').format(fecha);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una fecha';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  double monto = double.parse(montoController.text);
                  DateTime fecha =
                      DateFormat('yyyy-MM-dd').parse(fechaController.text);
                  String descripcion = descripcionController.text;
                  onAgregarGasto(monto, fecha, descripcion);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showDigitInputPopup(
      BuildContext context, Function(String) onDigitsEntered) {
    final TextEditingController digitController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Ingrese los 6 dígitos'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: digitController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: "",
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDigitsEntered(digitController.text);
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Formatter {
  static String formatCurrency(num amount) {
    return NumberFormat.simpleCurrency().format(amount);
  }
}
