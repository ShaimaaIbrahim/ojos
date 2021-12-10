class ProductModel {
  final String? image;
  final String? rateAvg;
  final String? type;
  final String? title;
  final String? colorCountAvailable;
  final String? price;
  final bool? isLenses;
  bool? isFavorite;
  ProductModel(
      {this.title,
      this.image,
      this.price,
      this.type,
      this.colorCountAvailable,
      this.isFavorite,
      this.rateAvg,
      this.isLenses});
}
