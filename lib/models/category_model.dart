class CategoryModel {
  final String id;
  final String name;
  final String type;
  final int iconCode;
  final String fontFamily;
  final String? color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.fontFamily,
    this.color,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'],
      type: data['type'],
      iconCode: data['iconCode'],
      fontFamily: data['fontFamily'],
      color: data['color'],
    );
  }
}
