class Cart {

   Cart({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity=1,
  });

  int productId;
  String title;
  double price;
  String image;
  int quantity;
}