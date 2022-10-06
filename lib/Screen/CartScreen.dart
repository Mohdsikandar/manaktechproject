import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:manektechtask/ColorFile/Colors.dart';
import 'package:manektechtask/Model/Itemmodel.dart';
import 'package:manektechtask/Database/db.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  int itemcount = 0; // this int use for total item in cart.

  late List<productdb> item;

  late String itemtitle,itemimg,itemprice;

  double amounttotal = 0; // this int use for total amount of product.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databasehandler = Databasehandler();
    totalitem();
  }

  late Databasehandler databasehandler;

  void totalitem()async{
    item = await databasehandler.retrieveUsers();
    setState((){
      itemcount = item.length;
      amounttotal = item.fold(0, (sum, item) => sum + int.parse(item.price));
    });
  }

  bool isLoading = false;


  // For Delete Item Slide item left side.

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("My Cart")),
          ),

          body: Container(
            //Using FutureBuilder for show data form DataBase.
            child:  FutureBuilder(
              future: this.databasehandler.retrieveUsers(),
              builder: (BuildContext context, AsyncSnapshot<List<productdb>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.delete_forever),
                        ),
                        key: ValueKey<int>(snapshot.data![index].id!),
                        onDismissed: (DismissDirection direction) async {
                          // This function use for delete the item when slide left side.
                          await this.databasehandler.deleteUser(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            child: Card(
                              elevation: 5,
                              shadowColor: Colors.grey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.network('${snapshot.data![index].img}',fit: BoxFit.fill,)),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${snapshot.data![index].name}",style: TextStyle(color: SecondaryColor,fontWeight: FontWeight.bold,fontSize: 15),),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Price:-",style: TextStyle(color: SecondaryColor),),
                                              Text("\u{20B9} ${snapshot.data![index].price}",style: TextStyle(color: SecondaryColor),)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Quantity:-",style: TextStyle(color: SecondaryColor),),
                                              Text("${snapshot.data![index].quantity}",style: TextStyle(color: SecondaryColor),),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        )
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          /*bottomSheet: Container(
            height: 50,
            color: PrimaryColor,
            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total item : ${itemcount}",style:TextStyle(color: Colors.white,fontSize: 15)),
                  Text("Grand Total : \u{20B9} ${amounttotal}",style:TextStyle(color: Colors.white,fontSize: 15))
                ],
              ),
            ),
          ),*/
          bottomNavigationBar: Container(
            height: 50,
            color: PrimaryColor,
            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total item : ${itemcount}",style:TextStyle(color: Colors.white,fontSize: 15)),
                  Text("Grand Total : \u{20B9} ${amounttotal}",style:TextStyle(color: Colors.white,fontSize: 15))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
