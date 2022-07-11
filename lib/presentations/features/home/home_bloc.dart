import 'dart:async';

import 'package:shopping_app/common/base/base_bloc.dart';
import 'package:shopping_app/common/base/base_event.dart';
import 'package:shopping_app/data/datasources/model/product_model.dart';
import 'package:shopping_app/data/repositorys/product_repository.dart';
import 'package:shopping_app/presentations/features/home/home_event.dart';

class HomeBloc extends BaseBloc{
  StreamController<List<ProductModel>> products = StreamController();
  StreamController<String> message = StreamController();
  late ProductRepository _productRepository;

  void setProductRepository({required ProductRepository productRepository}){
    _productRepository = productRepository;
  }

  @override
  void dispatch(BaseEvent event){
    if(event is FetchProductsEvent){
      fetchProducts();
    }
  }
  void fetchProducts() {
    loadingSink.add(true);
    _productRepository
        .fetchListProducts()
        .then((listProducts){
            //print(listProducts);
            if(listProducts!=null){
              products.sink.add(listProducts.map((productResponse) {
                return ProductModel(
                    productResponse.id,
                    productResponse.name,
                    productResponse.address,
                    productResponse.price,
                    productResponse.img,
                    productResponse.quantity,
                    productResponse.gallery);
              }).toList());
            }
        })
        .catchError((error){
          message.sink.add(error);
        }).whenComplete((){ loadingSink.add(false);});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}