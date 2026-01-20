class Wishlist  {

   const Wishlist({
     required this.productId,
     required this.title,
     required this.price,
     required this.image,
     required this.addedAt,
   });

   final int productId;
   final String title;
   final double price;
   final String image;
   final DateTime addedAt;
}
