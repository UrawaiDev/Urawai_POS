class Product {
  String id;
  String name;
  String image;
  double price;
  bool isRecommended = false;
  String category;
  double discount = 0;

  Product({
    this.id,
    this.name,
    this.image,
    this.price,
    this.isRecommended,
    this.category,
    this.discount,
  });
}
