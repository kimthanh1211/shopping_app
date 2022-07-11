import 'package:shopping_app/common/base/base_event.dart';

abstract class HomeEvent extends BaseEvent {}

class FetchProductsEvent extends HomeEvent {

  @override
  List<Object?> get props => [];
}