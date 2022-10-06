import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:manektechtask/BLoc/Bloc.dart';
import 'package:manektechtask/BLoc/BlocState.dart';
import 'package:manektechtask/ColorFile/Colors.dart';
import 'package:manektechtask/Database/db.dart';
import '../BLoc/BlocEvent.dart';
import '../Model/Itemmodel.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>  with WidgetsBindingObserver{

  int i = 0; //Add to cart upper counter

  late List<productdb> notes;

  late Databasehandler databasehandler;

  void gettotalitem() async {

    // this function use for get total item in cart

    this.notes = await databasehandler.retrieveUsers();
    setState(() {
      i = notes.length;
    });
  }

  int quantity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<Productbloc>(context).add(Getitemclass());
    WidgetsBinding.instance?.addObserver(this);
    databasehandler = Databasehandler();
    gettotalitem();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        gettotalitem(); //for updata the cart item on icon
        break;
    }

  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  bool botmvis = false;

  late String itemtitle,itemimg,itemprice;

  bool isLoading = false;


  Future<void> onRefresh() async => Future.delayed(
    const Duration(seconds: 2),
        () => setState(() =>  BlocProvider.of<Productbloc>(context).add(Getitemclass())),
  );

  void onEndOfPage() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        BlocProvider.of<Productbloc>(context).add(Getitemclass());
        gettotalitem();

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Center(child: const Text("Shopping Mall")),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 5,top: 2),
                child: Stack(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'Cartpage');
                        },
                        icon: Icon(Icons.shopping_cart,size: 30,)),
                    Positioned(
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: TextColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text("${i}",style: TextStyle(fontSize: 8,color: SecondaryColor),)))
                  ],
                ),
              )
            ],
          ),
          body: LazyLoadRefreshIndicator(
            onEndOfPage: onEndOfPage,
            onRefresh: onRefresh,
            scrollOffset: 150,
            isLoading: isLoading,
            child: Container(
                padding: EdgeInsets.all(10),
                child: OrientationBuilder(
                    // Using OrientationBuilder for screen Set Both Portrait & Landscape Screen.
                    builder: (context, orientation) {
                      return BlocBuilder<Productbloc,itemstate>(
                          builder: (context, state) {
                            print(state);
                            if (state is iteminitialstate || state is itemloading) {
                              return _buildLoading();
                            }  else if (state is itemsuccess) {
                              return GridView.count(
                                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children:List.generate(state.productModel.itemlist!.length, (index) {
                                    return GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          i++;
                                          botmvis = true; //Show bottomSheet
                                          itemtitle = state.productModel.itemlist![index].title.toString();
                                          itemprice = state.productModel.itemlist![index].price.toString();
                                          itemimg = state.productModel.itemlist![index].imgurl.toString();
                                        });
                                      },
                                      child: Card(
                                          margin: EdgeInsets.all(10),
                                          color: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation: 5,
                                          child: Container(
                                           padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 200,
                                                      child: Image.network('${state.productModel.itemlist![index].imgurl}',fit: BoxFit.fill,)),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(child: Text('${state.productModel.itemlist![index].title}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: SecondaryColor),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,softWrap: true,maxLines: 1,)),
                                                      Icon(Icons.shopping_cart,size: 25,color: SecondaryColor,)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    );

                                  })

                              );
                            } else if (state is itemerrorpage) {
                              return Container(
                                child: Text(state.erromsz),
                              );
                            } else {
                              return Container();
                            }

                          });
                    })
            ),
          ),
          bottomSheet: Visibility(
            visible: botmvis,
            child: Container(
              height: 50,
              color: PrimaryColor,
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Quantity: ",style:TextStyle(color: Colors.white,fontSize: 15)),
                        GestureDetector(
                          onTap: (){
                            if(quantity > 1){
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: SecondaryColor
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            child: Icon(Icons.remove),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: SecondaryColor
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Center(child: Text("${quantity}")),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: SecondaryColor
                                ),
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 30,
                      width: 60,
                      decoration: BoxDecoration(
                        color: PrimaryColor,
                        border: Border.all(
                            color: TextColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: ElevatedButton(
                        onPressed: (){

                          //Add item into db

                          int totalamnt = quantity * int.parse(itemprice);


                          productdb additem = productdb(name: itemtitle, price: totalamnt.toString(),quantity: quantity.toString(), img: itemimg);
                          List<productdb> listOfUsers = [additem];
                          databasehandler.insertUser(listOfUsers);

                          setState(() {
                            botmvis = false; //hide bottomSheet
                            quantity = 1;
                          });

                        },
                        child: Text("Add",style: TextStyle(fontSize: 10,color: TextColor),
                      ),
                    )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}


