class FoodItem {
  final String name;
  double quantity;
  final String unit;
  final Map<String, dynamic> nutrientsPer100g;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.nutrientsPer100g,
  });

  Map<String, double> calculateTotalNutrients() {
    final factor = quantity / 100; // Convert to 100g basis
    return {
      'calories': nutrientsPer100g['calories'] * factor,
      'protein': nutrientsPer100g['protein'] * factor,
      'carbohydrates': nutrientsPer100g['carbohydrates'] * factor,
      'fat': nutrientsPer100g['fat'] * factor,
      'fiber': nutrientsPer100g['fiber'] * factor,
      'sodium': nutrientsPer100g['sodium'] * factor,
      'sugar': nutrientsPer100g['sugar'] * factor,
      'calcium': nutrientsPer100g['calcium'] * factor,
      'cholesterol': nutrientsPer100g['cholesterol'] * factor,
      'iron': nutrientsPer100g['iron'] * factor,
    };
  }

  void updateQuantity(double newQuantity) {
    quantity = newQuantity;
  }
}
