class ClothSize {
  final int id;
  final String size;

  ClothSize({
    required this.id,
    required this.size
  });
}

class ShoeSize {
  final int id;
  final String size;

  ShoeSize({
    required this.id,
    required this.size
  });
}

class TrouserSize {
  final int id;
  final String size;

  TrouserSize({
    required this.id,
    required this.size
  });
}

List<ClothSize> clothsizes = [
  ClothSize(id: 1, size: "S"),
  ClothSize(id: 2, size: "M"),
  ClothSize(id: 3, size: "L"),
  ClothSize(id: 4, size: "XL"),
  ClothSize(id: 5, size: "XXL"),
  ClothSize(id: 6, size: "XXXL")
];

List<ShoeSize> shoeSizes = [
  ShoeSize(id: 1, size: "37"),
  ShoeSize(id: 2, size: "38"),
  ShoeSize(id: 3, size: "39"),
  ShoeSize(id: 4, size: "40"),
  ShoeSize(id: 5, size: "41"),
  ShoeSize(id: 6, size: "42"),
  ShoeSize(id: 7, size: "43"),
  ShoeSize(id: 8, size: "44"),
  ShoeSize(id: 9, size: "45"),
];

List<TrouserSize> trouserSizes = [
  TrouserSize(id: 1, size: "28"),
  TrouserSize(id: 2, size: "30"),
  TrouserSize(id: 3, size: "32"),
  TrouserSize(id: 4, size: "34"),
  TrouserSize(id: 5, size: "36"),
  TrouserSize(id: 6, size: "38"),
];