
import 'dart:core';

class ProductModel{
  String? msz;
  List<ProductModelArray>? itemlist;

  ProductModel({
    this.msz,
    this.itemlist,
  });

  ProductModel.fromJson(Map<String, dynamic> json){
    msz = json['message'];
    if (json['data'] != null) {
      itemlist = [];
      json['data'].forEach((v) {
        itemlist!.add(new ProductModelArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.msz;
    data['data'] = this.itemlist;
    return data;

  }

}

class ProductModelArray{
  String? title;
  int? price;
  String? imgurl;

  ProductModelArray({
    this.title,
    this.price,
    this.imgurl,
  });

  ProductModelArray.fromJson(Map<String, dynamic> json){
    title = json['title'];
    price =  json['price'];
    imgurl = json['featured_image'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    data['featured_image'] = this.imgurl;
    return data;

  }

}