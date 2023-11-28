class ApartmentModel {
  final String id;
  final String imageUrl;
  final String name;
  final int rent;
  final String contractEndDate;
  final String address;
  final int ipi;
  final String ipiDate;
  final int insuranceAnual;
  final int homeOwnerAssociation;

  ApartmentModel(
      {required this.id,
      required this.address,
      required this.ipiDate,
      required this.insuranceAnual,
      required this.homeOwnerAssociation,
      required this.ipi,
      required this.imageUrl,
      required this.name,
      required this.rent,
      required this.contractEndDate});
}
