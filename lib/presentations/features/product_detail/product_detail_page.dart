import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/presentations/features/product_detail/product_detail_bloc.dart';
import 'package:shopping_app/presentations/features/product_detail/product_detail_event.dart';

import '../../../common/base/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../../data/datasources/local/firebase/database/firebase_db.dart';
import '../../../data/datasources/model/product_model.dart';
import '../../../data/datasources/model/rating_model.dart';
import '../../../data/repositories/cart_repository.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../data/repositories/rating_repository.dart';

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
          Provider(create: (context)=>RatingRepository()),
          ProxyProvider2<CartRepository,RatingRepository,ProductDetailBloc>(
              create: (context)=>ProductDetailBloc(),
              update:(context,cartRepository,ratingRepository,bloc){
                bloc!.setRepository(cartRepository: cartRepository,ratingRepository:ratingRepository);
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
  //final _streamController = StreamController<int>();
  //Stream<int> get _stream => _streamController.stream;
  //Sink<int> get _sink => _streamController.sink;
  int initValue = 1;
  bool flagIsRelating = false;

  final _previewController = TextEditingController();
  late ProductDetailBloc productDetailBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8,initialPage: 1);
    //_sink.add(initValue);
    //_stream.listen((event) => _controller.text = event.toString());
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var dataReceive = ModalRoute.of(context)?.settings.arguments as Map;
    productModel =dataReceive["product"];
    productDetailBloc= context.read();
    //productDetailBloc.eventSink.add(ListenerRatingEvent(productId: productModel!.id));
    productDetailBloc.eventSink.add(GetRatingEvent(productId: productModel!.id));
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
          child: StreamBuilder<List<RatingModel>>(
              initialData: null,
              stream: productDetailBloc.listRating.stream,
              builder:(context, snapshot){
                print("test snapshot.data${snapshot.data}");
                 if (snapshot.hasError) {
                   return Center(
                     child: Text("Data is error"),
                   );
                 }
                 // if (snapshot.data == null || snapshot.data!.isEmpty) {
                 //   return Center(
                 //     child: Text("Data is empty"),
                 //   );
                 // }
                 return _contentProductDetail(snapshot.data??[]);
              }
          ),
        ),
      ),
    );
  }
  Widget _contentProductDetail(List<RatingModel> snapshot){
    ProductModel? product= productModel;
    if(product == null ) return Container();
    return SingleChildScrollView(
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
                    String token = AppCache.getString(VariableConstant.TOKEN);
                    if(token.isNotEmpty)
                      productDetailBloc.eventSink.add(AddCartByQtyEvent(idProduct: product.id,qty:initValue));
                    else
                      Navigator.pushNamed(context, "/sign-in");

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
              child: Text("Chi tiết sản phẩm...",style: TextStyle(fontSize: 16)),
            ),
            Divider(),
            _innerRating(),
            Divider(),
            _innerListRate(snapshot),
          ]
      ),
    );
  }

  Widget _innerListRate(List<RatingModel> listRating){
    if(listRating.length>0){
      return Column(
          children: [ 
            Padding(
                padding: EdgeInsets.all(10),
                child:Text(
                    "Danh sách đánh giá",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: listRating.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.blueGrey,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${listRating[index].accountId ?? ""}",
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: listRatingResult(listRating[index].rate?.toInt()??0)
                                ),
                                Text(
                                    "${listRating[index].createTime ?? ""}",
                                    style: TextStyle(fontSize: 14)),
                                Text(
                                    "${listRating[index].preview ?? ""}",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          )
          ]
      );
    }
    else return Container();
  }

  Widget _innerRating(){
    double _ratingValue = 3;

    if(!flagIsRelating)
      return Column(
        children: [
          const Text(
            'Đánh giá sản phẩm?',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 25),
          // implement the rating bar
          RatingBar(
            initialRating: _ratingValue as double,
            direction: Axis.horizontal,
            //allowHalfRating: true,
            allowHalfRating: false,
            itemCount: 5,
            ratingWidget: RatingWidget(
            full: const Icon(Icons.star, color: Colors.orange),
            half: const Icon(
            Icons.star_half,
            color: Colors.orange,
          ),
          empty: const Icon(
            Icons.star_outline,
            color: Colors.orange,
          )),
          onRatingUpdate: (value) {
            // setState(() {
            //
            // });
            _ratingValue = value;
        }),
        const SizedBox(height: 25),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            maxLines: 3,
            controller: _previewController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
            fillColor: Colors.black12,
            filled: true,
            hintText: "Nhập nội dung đánh giá...",
            labelStyle: TextStyle(color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
              enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
              //prefixIcon: Icon(Icons.email, color: Colors.blue),
            ),
          ),
        ),
        ElevatedButton(
          child: Text("Đánh giá",
          style: TextStyle(fontSize: 18, color: Colors.white)),
          onPressed: () {
            String _preview = _previewController.text.toString();
            String strAccountInfo,_accountEmail;
            strAccountInfo = AppCache.getString(VariableConstant.ACCOUNT_INFO);
            Map<String, dynamic> user = jsonDecode(strAccountInfo);
            _accountEmail=user['email'];
            // RatingModel rateModel = RatingModel(
            //     _accountEmail
            //     , _preview
            //     , _ratingValue
            //     , DateTime.now()
            // );
            // List<RatingModel> listRating = [];
            // listRating.add(rateModel);
            Map<String,Object> value = {
              "accountId":_accountEmail,
              "preview":_preview,
              "rate":_ratingValue,
              "createTime":DateTime.now().toString(),
            };
            //print(value);
            productDetailBloc.eventSink.add(PushRatingEvent(productId: productModel!.id,value:value));
            flagIsRelating =true;
            return;
          }
        ),
        ],
    );
    else return Text("Bạn đã đánh giá sản phẩm thành công!",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),);
  }

  List<Widget> listRatingResult(rate) {
    return List<Widget>.generate(rate, (index) {
      return Icon(
        Icons.star,
        color: Colors.orange,
        size: 20.0,
      );
    });
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



