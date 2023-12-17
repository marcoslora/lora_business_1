import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

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

  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey,
                ),
                child: const Text('OK')),
          ],
          elevation: 24.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
    );
  }

  static void showDigitInputPopup(
      BuildContext context, Function(String) onDigitsEntered) {
    final pinController = TextEditingController();
    final pinFocusNode = FocusNode();
    final isButtonActive = ValueNotifier<bool>(false);

    pinController.addListener(() {
      isButtonActive.value = pinController.text.length == 4;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Ingrese los 4 dígitos:'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                Pinput(
                  controller: pinController,
                  focusNode: pinFocusNode,
                  length: 4,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: isButtonActive,
                  builder: (context, isActive, child) {
                    return ElevatedButton(
                      onPressed: isActive
                          ? () {
                              Navigator.of(context).pop();
                              onDigitsEntered(pinController.text);
                            }
                          : null,
                      child: const Text('Confirmar'),
                    );
                  },
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
