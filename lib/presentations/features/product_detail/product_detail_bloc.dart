import 'dart:async';

import 'package:shopping_app/presentations/features/product_detail/product_detail_event.dart';

import '../../../common/base/base_bloc.dart';
import '../../../common/base/base_event.dart';
import '../../../data/datasources/model/cart_model.dart';
import '../../../data/datasources/model/product_model.dart';
import '../../../data/repositories/cart_repository.dart';

class ProductDetailBloc extends BaseBloc{
    StreamController<CartModel> cart = StreamController.broadcast();
    StreamController<String> message = StreamController();
    late CartRepository _cartRepository;

    void setRepository({required CartRepository cartRepository}){
      _cartRepository = cartRepository;
    }

    @override
    void dispatch(BaseEvent event){
      if (event is AddCartByQtyEvent) {
        addCartByQty(event);
      }
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

}