import 'package:flutter/material.dart';
import 'package:lora_business_1/src/models/apartmentsModel.dart';
import 'package:lora_business_1/src/models/pagosModels.dart';
import 'package:lora_business_1/src/models/spendsModel.dart';
import 'package:lora_business_1/src/repository/apartments_repository.dart';
import 'package:lora_business_1/src/utils/CustomPopup.dart';
import 'package:intl/intl.dart';
import 'package:lora_business_1/src/utils/globalValues.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final ApartmentModel apartment;
  final ValueNotifier<bool> mostrarIngresosNotifier = ValueNotifier(true);

  ApartmentDetailsPage({super.key, required this.apartment});
  void _mostrarDialogoAgregarIngreso(BuildContext context) {
    // Implemen floatingActionButton: FloatingActionButton(
    CustomPopUp.mostrarDialogoAgregarPago(context, apartment.id, apartment.name,
        (monto, fecha) {
      ApartmentsRepository()
          .agregarPago(apartment.id, apartment.name, monto, fecha);
    });
  }

  void _mostrarDialogoAgregarGasto(BuildContext context) {
    CustomPopUp.mostrarDialogoAgregarGasto(context, apartment.id,
        (monto, fecha, descripcion) {
      ApartmentsRepository().agregarGasto(apartment.id,
          SpendsModel(amount: monto, date: fecha, description: descripcion));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(apartment.imageUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apartment.name,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Renta ${Formatter.formatCurrency(apartment.rent)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(apartment.address,
                              style: const TextStyle(
                                fontSize: 16,
                              )),
                          const SizedBox(height: 3),
                          Text(
                              'Terminación del contrato: ${apartment.contractEndDate}'),
                          const SizedBox(height: 3),
                          Text(
                              'Ipi: \$${apartment.ipi}.00, 01/Sept/${DateTime.now().year}'),
                          const SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => mostrarIngresosNotifier.value = true,
                      icon: const Icon(Icons.monetization_on_outlined,
                          size: 30, color: Colors.green),
                      label: const Text('Ingresos',
                          style: TextStyle(color: Colors.green, fontSize: 20)),
                    ),
                    const SizedBox(width: 50),
                    TextButton.icon(
                      onPressed: () => mostrarIngresosNotifier.value = false,
                      icon: const Icon(Icons.monetization_on_outlined,
                          size: 30, color: Colors.red),
                      label: const Text('Gastos',
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ValueListenableBuilder<bool>(
            valueListenable: mostrarIngresosNotifier,
            builder: (context, value, child) {
              return value
                  ? _construirListaIngresos(apartment)
                  : _construirListaGastos(apartment);
            },
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: mostrarIngresosNotifier,
        builder: (context, mostrarIngresos, child) {
          return FloatingActionButton(
            onPressed: mostrarIngresos
                ? () => _mostrarDialogoAgregarIngreso(context)
                : () => _mostrarDialogoAgregarGasto(context),
            backgroundColor: mostrarIngresos ? Colors.blue : Colors.red,
            child: Icon(mostrarIngresos ? Icons.add : Icons.remove),
          );
        },
      ),
    );
  }
}

class PagoAgrupado {
  double total;
  List<PagoDetalle> detalles;

  PagoAgrupado({required this.total, required this.detalles});
}

class PagoDetalle {
  double monto;
  DateTime fecha;

  PagoDetalle({required this.monto, required this.fecha});
}

Map<String, PagoAgrupado> agruparPagosPorMes(List<PagoModels> pagos) {
  Map<String, PagoAgrupado> pagosPorMes = {};

  for (var pago in pagos) {
    String claveMes = DateFormat('MMMM yyyy', 'es_ES').format(pago.date);
    var pagoDetalle = PagoDetalle(monto: pago.amount, fecha: pago.date);

    if (!pagosPorMes.containsKey(claveMes)) {
      pagosPorMes[claveMes] = PagoAgrupado(total: 0, detalles: []);
    }

    pagosPorMes[claveMes]!.total += pago.amount;
    pagosPorMes[claveMes]!.detalles.add(pagoDetalle);
  }

  return pagosPorMes;
}

List<String> generarListaMeses() {
  var meses = <String>[];
  var fechaActual = DateTime.now();
  for (var i = 1; i <= 12; i++) {
    var mes = '${GlobalValues.mesesEnEspanol[i - 1]} ${fechaActual.year}';
    meses.add(mes);
  }
  return meses;
}

Widget _construirListaGastos(ApartmentModel apartment) {
  return Expanded(
    child: FutureBuilder<List<SpendsModel>>(
      future: ApartmentsRepository().obtenerGastosDeInquilino(apartment.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var gastosAgrupados = agruparGastosPorMes(snapshot.data!);
          return ListView(
            children: gastosAgrupados.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                    '${entry.key} - Total: ${Formatter.formatCurrency(entry.value.total)}'),
                children: entry.value.detalles.map((detalle) {
                  return ListTile(
                    title: Text(DateFormat('dd MMMM').format(detalle.fecha)),
                    subtitle: Text(detalle.descripcion),
                    trailing: Text(Formatter.formatCurrency(detalle.monto)),
                  );
                }).toList(),
              );
            }).toList(),
          );
        } else {
          return const Text('No hay gastos disponibles');
        }
      },
    ),
  );
}

Widget _construirListaIngresos(ApartmentModel apartment) {
  return Expanded(
    child: FutureBuilder<List<PagoModels>>(
      future: ApartmentsRepository().obtenerPagosDeInquilino(apartment.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var pagosAgrupados = agruparPagosPorMes(snapshot.data!);

          // Ordenar las entradas por clave (mes y año) de manera descendente
          var entradasOrdenadas = pagosAgrupados.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));

          return ListView(
            children: entradasOrdenadas.map((entry) {
              DateTime fecha;
              try {
                fecha = DateFormat('MMMM yyyy', 'es_ES').parse(entry.key);
              } catch (e) {
                return const SizedBox.shrink();
              }

              Color backgroundColor = entry.value.total >= apartment.rent
                  ? Colors.lightGreen
                  : Colors.redAccent;

              return ExpansionTile(
                title: Container(
                  padding: const EdgeInsets.all(10),
                  color: backgroundColor.withOpacity(0.2),
                  child: Text(
                    '${DateFormat('MMMM yyyy', 'es_ES').format(fecha)} - Total: ${Formatter.formatCurrency(entry.value.total)}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                children: entry.value.detalles.map((detalle) {
                  return ListTile(
                    title: Text(DateFormat('dd MMMM').format(detalle.fecha)),
                    trailing: Text(Formatter.formatCurrency(detalle.monto)),
                  );
                }).toList(),
              );
            }).toList(),
          );
        } else {
          return const Text('No hay pagos disponibles');
        }
      },
    ),
  );
}

class GastoAgrupado {
  double total;
  List<GastoDetalle> detalles;

  GastoAgrupado({required this.total, required this.detalles});
}

class GastoDetalle {
  double monto;
  DateTime fecha;
  String descripcion;

  GastoDetalle(
      {required this.monto, required this.fecha, required this.descripcion});
}

Map<String, GastoAgrupado> agruparGastosPorMes(List<SpendsModel> gastos) {
  Map<String, GastoAgrupado> gastosPorMes = {};

  for (var gasto in gastos) {
    String claveMes = DateFormat('MMMM yyyy', 'es_ES').format(gasto.date);
    var gastoDetalle = GastoDetalle(
        monto: gasto.amount, fecha: gasto.date, descripcion: gasto.description);

    if (!gastosPorMes.containsKey(claveMes)) {
      gastosPorMes[claveMes] = GastoAgrupado(total: 0, detalles: []);
    }

    gastosPorMes[claveMes]!.total += gasto.amount;
    gastosPorMes[claveMes]!.detalles.add(gastoDetalle);
  }

  return gastosPorMes;
}
