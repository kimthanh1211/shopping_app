import '../../../common/base/base_event.dart';

abstract class ProductDetailEvent extends BaseEvent {}


class AddCartByQtyEvent extends ProductDetailEvent {

  String idProduct;
  int qty;

  AddCartByQtyEvent({required this.idProduct,required this.qty});

  @override
  List<Object?> get props => [idProduct,qty];
}

class AddCartByQtySuccessEvent extends ProductDetailEvent{
  AddCartByQtySuccessEvent();

  @override
  List<Object> get props =>[];

}

class PushRatingEvent extends ProductDetailEvent{
  String productId;
  Map<String,Object> value;
  PushRatingEvent({required this.productId,required this.value});

  @override
  List<Object> get props =>[];

}
class ListenerRatingEvent extends ProductDetailEvent{
  String productId;
  ListenerRatingEvent({required this.productId});

  @override
  List<Object> get props =>[];

}

class GetRatingEvent extends ProductDetailEvent{
  String productId;
  GetRatingEvent({required this.productId});

  @override
  List<Object> get props =>[];

}