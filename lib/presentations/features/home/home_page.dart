import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/common/base/base_widget.dart';
import 'package:shopping_app/data/datasources/model/cart_model.dart';
import 'package:shopping_app/data/repositories/product_repository.dart';
import 'package:shopping_app/presentations/features/home/home_bloc.dart';

import '../../../common/constants/api_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/datasources/model/product_model.dart';
import '../../../data/repositories/cart_repository.dart';
import 'home_event.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ProductRepository repository = ProductRepository();
    repository.fetchListProducts().then((value) => print(value)).catchError((e)=> print(e));

  }


  @override
  Widget build(BuildContext context) {
    return PageContainer(
        providers: [
          Provider(create: (context)=>ProductRepository()),
          Provider(create: (context)=>CartRepository()),
          ProxyProvider2<ProductRepository, CartRepository,HomeBloc>(
              create: (context) => HomeBloc(),
              update: (context, productRepo, cartRepo, bloc) {
                bloc!.setRepository(productRepository: productRepo, cartRepository: cartRepo);
                return bloc;
              })
        ],
        appBar: AppBar(
            title: Text("Home"),
            actions:[
              Container(
                margin: EdgeInsets.only(right: 5, top: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/order-history");
                    },
                    icon: Icon(Icons.description)
                ),
              ),
              Consumer<HomeBloc>(
                builder: (context,bloc,child){
                  return InkWell(
                    onTap: (){
                      Navigator
                          .pushNamed(context, "/cart")
                          .then((cartModelUpdate){
                            if (cartModelUpdate != null) {
                              bloc.cart.sink.add(cartModelUpdate as CartModel);
                            }
                          });
                    },
                    child: StreamBuilder<CartModel>(
                      initialData: null,
                      stream: bloc.cart.stream,
                      builder:(context,snapshot){
                        if(snapshot.hasError||snapshot.data==null) return Container();
                        String? count = snapshot.data?.products?.length.toString();
                        if(count == null||count.isEmpty||count == "0"){
                          return Container(
                              margin: EdgeInsets.only(right: 10, top: 10),
                              child: Icon(Icons.shopping_cart_outlined)
                          );
                        }
                        else{
                          return Container(
                              margin: EdgeInsets.only(right: 5, top: 10),
                              child: Badge(
                                  badgeContent: Text(count),
                                  child: Icon(Icons.shopping_cart_outlined)
                              )
                          );
                        }
                      }
                    ),
                  );
                }

              )
              ,Container(
                margin: EdgeInsets.only(right: 0, top: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                    icon: Icon(Icons.account_circle)
                ),
              ),
            ],
        )
        , child: HomeContainer());
  }

}

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late HomeBloc homeBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeBloc = context.read();
    homeBloc.fetchProducts();
    homeBloc.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      bloc: homeBloc,
      child: StreamBuilder<List<ProductModel>>(
          initialData: [],
          stream: homeBloc.products.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Data is error");
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _buildItemFood(snapshot.data?[index]);
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _buildItemFood(ProductModel? product) {
    if (product == null) return Container();
    return Container(
      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(ApiConstant.BASE_URL + product.img,
                    width: 150, height: 120, fit: BoxFit.fill),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(product.name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(
                          "Giá : " +
                              NumberFormat("#,###", "en_US")
                                  .format(product.price) +
                              " đ",
                          style: TextStyle(fontSize: 12)),
                      ElevatedButton(
                        onPressed: () {
                          homeBloc.eventSink.add(AddCartEvent(idProduct: product.id));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color.fromARGB(200, 240, 102, 61);
                              } else {
                                return Color.fromARGB(230, 240, 102, 61);
                              }
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))))),
                        child:
                        Text("Add To Cart", style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
