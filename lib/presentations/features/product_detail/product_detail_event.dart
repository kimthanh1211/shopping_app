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