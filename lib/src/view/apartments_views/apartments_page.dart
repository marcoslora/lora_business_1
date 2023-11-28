import 'package:flutter/material.dart';
import 'package:lora_business_1/src/Widgets/apartments_widgets.dart';
import 'package:lora_business_1/src/models/apartmentsModel.dart';

class ApartmentsPage extends StatelessWidget {
  const ApartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Apartments', style: TextStyle(color: Colors.black)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas
          crossAxisSpacing: 10, // Espaciado horizontal  entre las tarjetas
          mainAxisSpacing: 10, // Espaciado vertical entre las tarjetas
          childAspectRatio: 0.75, // Relación de aspecto de las tarjetas
        ),
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          return buildApartmentCard(context, apartments[index]);
        },
      ),
    );
  }
}

List<ApartmentModel> apartments = [
  ApartmentModel(
      id: "1",
      imageUrl:
          'https://uphomesimages.com/bdomls/c415b43e05a791f9c3ca7bba87ccf9a1/main/image-c415b43e05a791f9c3ca7bba87ccf9a1-0.jpg',
      name: 'Gustavo',
      rent: 1200,
      ipi: 974,
      ipiDate: "01/09/2023",
      insuranceAnual: 600,
      homeOwnerAssociation: 268,
      address: '4721 WALDEN POND DR # C',
      contractEndDate: "31/12/2023"),
  ApartmentModel(
    id: "2",
    imageUrl:
        'https://uphomesimages.com/bdomls/c415b43e05a791f9c3ca7bba87ccf9a1/main/image-c415b43e05a791f9c3ca7bba87ccf9a1-0.jpg',
    name: 'Apartment 2',
    address: 'Calle 1, #1, Santo Domingo',
    ipiDate: "01/09/2023",
    ipi: 100,
    insuranceAnual: 600,
    homeOwnerAssociation: 268,
    rent: 1200,
    contractEndDate: '31/12/2023',
  ),
  ApartmentModel(
    id: "3",
    imageUrl:
        'https://uphomesimages.com/bdomls/c415b43e05a791f9c3ca7bba87ccf9a1/main/image-c415b43e05a791f9c3ca7bba87ccf9a1-0.jpg',
    name: 'Apartment 3',
    address: 'Calle 1, #1, Santo Domingo',
    ipiDate: "01/09/2023",
    insuranceAnual: 100,
    homeOwnerAssociation: 600,
    ipi: 100,
    rent: 1200,
    contractEndDate: '31/12/2023',
  ),
  ApartmentModel(
    id: "4",
    imageUrl:
        'https://uphomesimages.com/bdomls/c415b43e05a791f9c3ca7bba87ccf9a1/main/image-c415b43e05a791f9c3ca7bba87ccf9a1-0.jpg',
    name: 'Apartment 3',
    address: 'Calle 1, #1, Santo Domingo',
    ipiDate: "01/09/2023",
    insuranceAnual: 100,
    homeOwnerAssociation: 600,
    ipi: 100,
    rent: 1200,
    contractEndDate: '31/12/2023',
  ),
  ApartmentModel(
    id: "5",
    imageUrl:
        'https://uphomesimages.com/bdomls/c415b43e05a791f9c3ca7bba87ccf9a1/main/image-c415b43e05a791f9c3ca7bba87ccf9a1-0.jpg',
    name: 'Apartment 3',
    address: 'Calle 1, #1, Santo Domingo',
    ipiDate: "01/09/2023",
    insuranceAnual: 100,
    homeOwnerAssociation: 600,
    ipi: 100,
    rent: 1200,
    contractEndDate: '31/12/2023',
  ),
];
