import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manektechtask/BLoc/Bloc.dart';
import 'package:manektechtask/ColorFile/Colors.dart';
import 'package:manektechtask/Screen/CartScreen.dart';
import 'Screen/HomeScreen.dart';

void main() async{
  BlocOverrides.runZoned((){
    runApp(const MyApp());
  },
  blocObserver:  ProductBlocObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => Productbloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
         primaryColor: PrimaryColor
        ),
        routes: {
          'Cartpage':(context) => CartScreen(),
          'homepage':(context) => Homescreen()
        },
        home: Homescreen(),
      ),
    );
  }
}

class ProductBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}