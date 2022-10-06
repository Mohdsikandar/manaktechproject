import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manektechtask/Model/ModelPage.dart';

class Apiclass{

  Future<ProductModel?> getproductdata() async {
    try {
      var url = Uri.parse('http://205.134.254.135/~mobile/MtProject/public/api/product_list');
      final http.Response response = await http.get(url);
      print(response);

      if(response.statusCode == 200){
        return ProductModel.fromJson(json.decode(response.body));
      }else{

        throw Exception('Failed');
      }

    } catch (e) {
      throw Exception('Failed');
    }
  }
}