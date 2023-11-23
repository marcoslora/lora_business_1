import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lora_business_1/src/models/pagosModels.dart';

class ApartmentsRepository {
  final CollectionReference _inquilinosCollection =
      FirebaseFirestore.instance.collection('inquilinos');

  Future<void> agregarPago(String inquilinoId, PagoModels pago) async {
    await _inquilinosCollection.doc(inquilinoId).collection('pagos').add({
      'monto': pago.monto,
      'fecha': pago.fecha,
    });
  }

  Future<List<PagoModels>> obtenerPagosDeInquilino(String inquilinoId) async {
    QuerySnapshot querySnapshot =
        await _inquilinosCollection.doc(inquilinoId).collection('pagos').get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return PagoModels(
        monto: data['monto'],
        fecha: (data['fecha'] as Timestamp).toDate(),
      );
    }).toList();
  }
}
