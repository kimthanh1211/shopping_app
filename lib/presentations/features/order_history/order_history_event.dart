import 'package:shopping_app/common/base/base_event.dart';

abstract class OrderHistoryEvent extends BaseEvent {}

class FetchOrderHistoryEvent extends OrderHistoryEvent {

  @override
  List<Object?> get props => [];
}
