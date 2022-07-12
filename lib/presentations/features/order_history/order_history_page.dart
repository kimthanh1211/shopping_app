import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/common/base/base_widget.dart';
import 'package:shopping_app/common/widgets/loading_widget.dart';
import 'package:shopping_app/data/datasources/model/order_model.dart';
import 'package:shopping_app/data/repositories/order_repository.dart';
import 'package:shopping_app/presentations/features/order_history/order_history_bloc.dart';
import 'package:shopping_app/presentations/features/order_history/order_history_event.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/api_constant.dart';
import '../../../data/datasources/model/product_model.dart';
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => OrderRepository()),
        ProxyProvider<OrderRepository, OrderHistoryBloc>(
            create: (context) => OrderHistoryBloc(),
            update: (context, repository, bloc) {
              bloc!.setOrderRepository(orderRepository: repository);
              return bloc;
            }
        )
      ],
      appBar: AppBar(
        title: Text("Order History"),
      ),
      child: OrderHistoryContainer(),
    );
  }
}

class OrderHistoryContainer extends StatefulWidget {
  const OrderHistoryContainer({Key? key}) : super(key: key);

  @override
  State<OrderHistoryContainer> createState() => _OrderHistoryContainerState();
}

class _OrderHistoryContainerState extends State<OrderHistoryContainer> {
  late OrderHistoryBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read();
    _bloc.eventSink.add(FetchOrderHistoryEvent());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: LoadingWidget(
            bloc: _bloc,
            child: StreamBuilder<List<OrderModel>>(
              initialData: null,
              stream: _bloc.listOrder.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Data is error"),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Data is empty"),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return itemList(snapshot.data?[index]);
                    }
                );
              },
            ),
          ),
        )
    );
  }

  Widget itemList (OrderModel? orderModel) {
    if (orderModel == null) return Container();
    return Container(
      height: 220,
      //constraints: BoxConstraints.expand(),
      //height: MediaQuery.of(context).size.height,
      child: Card(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text("Đơn hàng: #${  orderModel.id ??= ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16,color: Colors.red)),
                      ),
                      Text(
                          "Trạng thái: ${  orderModel.status ?? 0}",
                          style: TextStyle(fontSize: 14)),
                      Text(
                          "Thời gian đặt hàng: ${  orderModel.date_created ??= ""}",
                          style: TextStyle(fontSize: 14)),
                      itemListImage(orderModel.products ?? null),
                      Text(
                          "Tổng cộng : " +
                              NumberFormat("#,###", "en_US")
                                  .format(orderModel.price ??= 0) +
                              " đ",
                          style: TextStyle(fontSize: 16))
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

  Widget itemListImage (List<ProductModel>? productModels) {
    if(productModels != null && productModels.length>0){
      return Flexible(
        child: ListView.builder(
            itemCount: productModels.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(ApiConstant.BASE_URL + productModels[index].img,
                          width: 50, height: 50, fit: BoxFit.fill),
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
                              child: Text(productModels[index].name.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16)),
                            ),
                            Text(
                                "Giá : " +
                                    NumberFormat("#,###", "en_US")
                                        .format(productModels[index].price) +
                                    " đ",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        ),

      );
    }
    else
      return Container();
  }
}

