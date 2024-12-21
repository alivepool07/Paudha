class Crop {
  final int id;
  final String name;
  final int dimX;
  final int dimY;

  Crop({
    required this.id,
    required this.name,
    required this.dimX,
    required this.dimY,
  });

  // Factory constructor to create a Crop instance from JSON
  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      dimX: json['dimX'],
      dimY: json['dimY'],
    );
  }
}
