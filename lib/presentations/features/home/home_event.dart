import 'package:shopping_app/common/base/base_event.dart';

abstract class HomeEvent extends BaseEvent {}

class FetchProductsEvent extends HomeEvent {

  @override
  List<Object?> get props => [];
}

class AddCartEvent extends HomeEvent {

  String idProduct;

  AddCartEvent({required this.idProduct});

  @override
  List<Object?> get props => [idProduct];
}