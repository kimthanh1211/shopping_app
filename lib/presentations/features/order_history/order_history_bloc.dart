import 'dart:async';

import 'package:shopping_app/common/base/base_bloc.dart';
import 'package:shopping_app/common/base/base_event.dart';
import 'package:shopping_app/data/datasources/model/order_model.dart';
import 'package:shopping_app/data/datasources/model/product_model.dart';
import 'package:shopping_app/data/repositories/order_repository.dart';
import 'package:shopping_app/presentations/features/order_history/order_history_event.dart';

class OrderHistoryBloc extends BaseBloc {
  StreamController<List<OrderModel>> listOrder = StreamController();
  StreamController<String> message = StreamController();
  late OrderRepository _repository;

  void setOrderRepository({required OrderRepository orderRepository}) {
    _repository = orderRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    if (event is FetchOrderHistoryEvent) {
      fetchOrderHistory(event);
    }
  }

  void fetchOrderHistory(FetchOrderHistoryEvent event) {
    loadingSink.add(true);
    _repository.fetchOrderHistory().then((orderListsData) {
      listOrder.sink.add(orderListsData.map((order) {
        return OrderModel(
            order.id,
            order.products
                ?.map((productResponse) => ProductModel(
                productResponse.id,
                productResponse.name,
                productResponse.address,
                productResponse.price,
                productResponse.img,
                productResponse.quantity,
                productResponse.gallery))
                .toList(),
            order.price,
            order.status,
            order.date_created);
        }).toList()
        ..sort((b, a) => a.date_created!.compareTo(b.date_created!)) // (a,b): asc , (b,a): desc
      );



    }).catchError((e) {
      message.sink.add(e);
    }).whenComplete(() => loadingSink.add(false));
  }

  @override
  void dispose() {
    super.dispose();
    listOrder.close();
    message.close();
  }
}
