import 'dart:async';

import 'package:shopping_app/data/datasources/model/rating_model.dart';
import 'package:shopping_app/data/repositories/rating_repository.dart';
import 'package:shopping_app/presentations/features/product_detail/product_detail_event.dart';

import '../../../common/base/base_bloc.dart';
import '../../../common/base/base_event.dart';
import '../../../data/datasources/model/cart_model.dart';
import '../../../data/datasources/model/product_model.dart';
import '../../../data/repositories/cart_repository.dart';



class ProductDetailBloc extends BaseBloc{
    StreamController<List<RatingModel>> listRating = StreamController();
    StreamController<CartModel> cart = StreamController.broadcast();
    StreamController<String> message = StreamController();
    late CartRepository _cartRepository;
    late RatingRepository _ratingRepository;

    void setRepository({required CartRepository cartRepository,required RatingRepository ratingRepository}){
      _cartRepository = cartRepository;
      _ratingRepository = ratingRepository;
    }

    @override
    void dispatch(BaseEvent event){
      if (event is AddCartByQtyEvent) {
        addCartByQty(event);
      }
      else if (event is PushRatingEvent) {
        pushRatingEvent(event);
      }
      else if (event is GetRatingEvent) {
        getRatingEvent(event);
      }
      // else if (event is ListenerRatingEvent) {
      //   listenerRatingEvent(event);
      // }
    }
    // void listenerRatingEvent(ListenerRatingEvent event){
    //     loadingSink.add(true);
    //     _ratingRepository.listenerRatingProduct(productId: event.productId);
    //     loadingSink.add(false);
    // }
    void getRatingEvent(GetRatingEvent event) async{
        loadingSink.add(true);
        List<RatingModel>? data = await _ratingRepository.getRatingProduct(productId: event.productId);
        if(data !=null && data.length>0)
          listRating.sink.add(data..sort((b, a) => a.createTime!.compareTo(b.createTime!)));//sort createTime desc
        loadingSink.add(false);
    }

    void pushRatingEvent(PushRatingEvent event){
        loadingSink.add(true);
        //print("set data 2: ${event.productId},${event.value}");
        _ratingRepository.pushRatingProduct(productId: event.productId, value: event.value);
        //progressSink.add(GetRatingEvent(productId: event.productId));
        getRatingEvent(GetRatingEvent(productId: event.productId));
        loadingSink.add(false);
    }
    void addCartByQty(AddCartByQtyEvent event) {
      loadingSink.add(true);
      if(event.qty == 1){
        _cartRepository
            .addCart(event.idProduct)
            .then((cartData) => cart.sink.add(CartModel(
            cartData.id,
            cartData.products?.map((model) => ProductModel(
                model.id,
                model.name,
                model.address,
                model.price,
                model.img,
                model.quantity,
                model.gallery))
                .toList(),
            cartData.price)))
            .catchError((e) {
          message.sink.add(e);
        }).whenComplete(() {
          progressSink.add(AddCartByQtySuccessEvent());
          loadingSink.add(false);
        });
      }
      else if(event.qty > 1){
        //add product to card width qty
      }

    }

    @override
    void dispose() {
      super.dispose();
      cart.close();
      listRating.close();
      message.close();
    }
}