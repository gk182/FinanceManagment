class Category {
  final String id;
  final String name;
  final String type; // 'income' hoặc 'expense'
  final int iconCode;
  final String fontFamily;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.fontFamily,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'iconCode': iconCode,
      'fontFamily': fontFamily,
      'color': color,
    };
  }

  factory Category.fromMap(String id, Map<String, dynamic> map) {
    return Category(
      id: id,
      name: map['name'],
      type: map['type'],
      iconCode: map['iconCode'],
      fontFamily: map['fontFamily'],
      color: map['color'],
    );
  }
}
