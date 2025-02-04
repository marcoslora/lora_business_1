import 'package:flutter/material.dart';
import 'package:lora_business_1/src/models/apartmentsModel.dart';
import 'package:lora_business_1/src/utils/CustomPopup.dart';
import 'package:lora_business_1/src/view/apartments_views/apartments_detail.dart';

Widget buildApartmentCard(BuildContext context, ApartmentModel apartment) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApartmentDetailsPage(apartment: apartment),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.blueGrey[100],
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              apartment.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apartment.address,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text(apartment.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),

                Text(Formatter.formatCurrency(apartment.rent)),
                // Text(
                //     'Contract End: ${apartment.contractEndDate}'), // Fecha de vencimiento del contrato
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
