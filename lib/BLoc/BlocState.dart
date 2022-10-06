import 'package:manektechtask/Model/ModelPage.dart';

abstract class itemstate {}

class iteminitialstate extends itemstate {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class itemloading extends itemstate {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class itemsuccess extends itemstate {


  ProductModel productModel;
  itemsuccess(this.productModel);

  @override
  // TODO: implement props
  List<Object> get props => [];



}

class itemerrorpage extends itemstate {

  final String erromsz;

  itemerrorpage({
    required this.erromsz
  });

  //itemerrorpage(this.erromsz);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
