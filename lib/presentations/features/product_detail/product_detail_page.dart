import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/presentations/features/product_detail/product_detail_bloc.dart';
import 'package:shopping_app/presentations/features/product_detail/product_detail_event.dart';

import '../../../common/base/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/model/product_model.dart';
import '../../../data/repositories/cart_repository.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  @override
  Widget build(BuildContext context) {
    return PageContainer(
        providers: [
          Provider(create: (context)=>CartRepository()),
          ProxyProvider<CartRepository,ProductDetailBloc>(
              create: (context)=>ProductDetailBloc(),
              update:(context,repository,bloc){
                bloc!.setRepository(cartRepository: repository);
                return bloc;
              }
          )
        ],
        appBar: AppBar(
        title: Text("Chi tiết sản phẩm"),
        ),
        child:DetailProductDetailContainer()
    );
  }

}

class DetailProductDetailContainer extends StatefulWidget {
  const DetailProductDetailContainer({Key? key}) : super(key: key);

  @override
  State<DetailProductDetailContainer> createState() => _DetailProductDetailContainerState();
}

class _DetailProductDetailContainerState extends State<DetailProductDetailContainer> {
  ProductModel? productModel;
  PageController? _pageController;
  int activePage = 1;
  //final _controller = TextEditingController();
  final _streamController = StreamController<int>();
  //Stream<int> get _stream => _streamController.stream;
  Sink<int> get _sink => _streamController.sink;
  int initValue = 1;

  late ProductDetailBloc productDetailBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8,initialPage: 1);
    _sink.add(initValue);
    //_stream.listen((event) => _controller.text = event.toString());
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var dataReceive = ModalRoute.of(context)?.settings.arguments as Map;
    productModel =dataReceive["product"];

    productDetailBloc= context.read();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingWidget(
        bloc: productDetailBloc,
        child: ProgressListenerWidget<ProductDetailBloc>(
          callback: (event){
            print(event.runtimeType);
            if(event is AddCartByQtySuccessEvent){
              Navigator.pushNamed(context, "/cart");
            }
          },
          child: _contentProductDetail(),
        ),
      ),
    );
  }
  Widget _contentProductDetail(){
    ProductModel? product= productModel;
    if(product == null ) return Container();
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(product.name,style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
            // Container(
            //   child: Image.network(
            //       ApiConstant.BASE_URL + product.img,
            //       width: MediaQuery.of(context).size.width, height: 300, fit: BoxFit.fill
            //   ),
            // ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: PageView.builder(
                      itemCount: product.gallery.length,
                      pageSnapping: true,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        bool active = pagePosition == activePage;
                        return slider(product.gallery,pagePosition,active);
                      }),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(product.gallery.length,activePage)
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Giá: ${NumberFormat("#,###", "en_US").format(product.price)}"
                  ,style: TextStyle(fontSize: 20)
              ),
            ),
            // Row(
            //   children: [
            //     Padding(padding: EdgeInsets.all(10),child: Text("Chọn số lượng:",style: TextStyle(fontSize: 20))),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if (initValue > 0) {
            //             _sink.add(--initValue);
            //           }
            //         });
            //       },
            //       child: Text("-"),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 15),
            //       child: Text("$initValue",
            //           style: TextStyle(fontSize: 16)),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if (initValue < 10) {
            //             _sink.add(++initValue);
            //           }else
            //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Số lượng đặt hàng <= 10",style: TextStyle(color:Colors.red),)));
            //         });
            //       },
            //       child: Text("+"),
            //     ),
            //   ]
            //   ,
            // ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top:20),
                child: ElevatedButton(
                  onPressed: () {
                    productDetailBloc.eventSink.add(AddCartByQtyEvent(idProduct: product.id,qty:initValue));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.deepOrange)),
                  child: Text("Thêm vào giỏ",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Chi tiết sản phẩm",style: TextStyle(fontSize: 16)),
            )
          ]
      ),
    );
  }

  List<Widget> indicators(imagesLength,currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  AnimatedContainer slider(images,pagePosition,active){
    double margin = active ? 10 : 20;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  ApiConstant.BASE_URL + images[pagePosition]
              )
          )
      ),
    );
  }
}



