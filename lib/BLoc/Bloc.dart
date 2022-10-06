import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manektechtask/Apirepository/apirepo.dart';
import 'package:manektechtask/BLoc/BlocEvent.dart';
import 'package:manektechtask/BLoc/BlocState.dart';

class Productbloc extends Bloc<itemevent,itemstate>{

  Productbloc() : super (iteminitialstate()){

    final Apiclass rechargeapi = Apiclass();

    on<Getitemclass>((event, emit) async {

      try{
        emit(itemloading());
        final mList = await rechargeapi.getproductdata();
        emit(itemsuccess(mList!));
      } catch(e) {
        emit(itemerrorpage(erromsz: e.toString()));
      }

    });


  }


}