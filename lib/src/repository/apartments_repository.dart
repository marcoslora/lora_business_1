import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lora_business_1/src/models/pagosModels.dart';
import 'package:lora_business_1/src/models/spendsModel.dart';

class ApartmentsRepository {
  Future<void> agregarPago(
      String apartmentId, String userId, double amount, DateTime date) async {
    DocumentReference apartmentDoc =
        FirebaseFirestore.instance.collection('apartments').doc(apartmentId);

    await apartmentDoc.collection('amount').add({
      'userId': userId,
      'amount': amount,
      'date': date,
    });
  }

  Future<void> agregarGasto(String inquilinoId, SpendsModel gasto) async {
    DocumentReference inquilinoDoc =
        FirebaseFirestore.instance.collection('inquilinos').doc(inquilinoId);

    await inquilinoDoc.collection('gastos').add({
      'amount': gasto.amount,
      'date': gasto.date,
      'description': gasto.description,
    });
  }

  Future<String> obtenerNombreInquilino(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    var data = userDoc.data() as Map<String, dynamic>?;
    return data?['name'] ?? 'Nombre no disponible';
  }

  Future<List<PagoModels>> obtenerPagosDeInquilino(String inquilinoId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('apartments')
        .doc(inquilinoId)
        .collection('amount')
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return PagoModels(
        amount: data['amount'],
        date: (data['date'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<List<SpendsModel>> obtenerGastosDeInquilino(String inquilinoId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('inquilinos')
        .doc(inquilinoId)
        .collection('gastos')
        .get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return SpendsModel(
        amount: data['amount'],
        date: (data['date'] as Timestamp).toDate(),
        description: data['description'],
      );
    }).toList();
  }
}
