class Motorcycle{
  final String id;
  final String brand;
  final String model;
  final String? image;
  final num? yearOfManufacture;
  final num? ccm;
  num? consumption;

  Motorcycle({
    required this.id,
    required this.brand,
    required this.model,
    this.image,
    this.yearOfManufacture,
    this.ccm,
    this.consumption,
  });

  factory Motorcycle.fromJson(Map<String, dynamic> json){
    return Motorcycle(
      id: json['_id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      image: json['image'] as String?,
      yearOfManufacture: json['yearOfManufacture'] as num?,
      ccm: json['ccm'] as num?,
      consumption: json['consumption'] as num?,
    );
  }
}