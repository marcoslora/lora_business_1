class ApartmentModel {
  final String id;
  final String imageUrl;
  final String name;
  final double rent;
  final String contractEndDate;

  ApartmentModel(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.rent,
      required this.contractEndDate});
}
