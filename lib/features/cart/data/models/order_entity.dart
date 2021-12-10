class OrderEntity {
  int? product_id;
  int? type_product;
  int? quantity;
  double? price;
  int? RightSPH;
  int? RightCYL;
  int? RightAXI;

  int? LeftSPH;
  int? LeftCYL;
  int? LeftAXI;

  int? APD;
  int? IPD;

  OrderEntity(
      {this.product_id,
      this.type_product,
      this.quantity,
      this.price,
      this.RightSPH,
      this.RightCYL,
      this.RightAXI,
      this.LeftSPH,
      this.LeftCYL,
      this.LeftAXI,
      this.APD,
      this.IPD});
}
