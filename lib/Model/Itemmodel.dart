class productdb {
  final int? id;
  final String name;
  final String price;
  final String quantity;
  final String img;
  productdb(
      { this.id,
        required this.name,
        required this.price,
        required this.quantity,
        required this.img
      });

  productdb.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        price = res["price"],
        quantity = res["qty"],
        img = res["image"];


  Map<String, Object?> toMap() {
    return {'id':id,'name': name,'price':price,'qty':quantity,'image':img};
  }
}