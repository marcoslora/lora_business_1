import 'package:flutter/material.dart';
import 'package:lora_business_1/src/models/apartmentsModel.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final ApartmentModel apartment;

  const ApartmentDetailsPage({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(apartment.imageUrl),
            Text('\$${apartment.rent}', style: const TextStyle(fontSize: 24)),
            Text('Contract End: ${apartment.contractEndDate}'),
          ],
        ),
      ),
    );
  }
}
