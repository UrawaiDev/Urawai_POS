class Product {
  int id;
  String name;
  String image;
  double price;
  bool isRecommended = false;
  int category;
  int discount = 0;

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