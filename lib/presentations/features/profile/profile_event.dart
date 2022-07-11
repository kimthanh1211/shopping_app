import 'package:shopping_app/common/base/base_event.dart';

abstract class ProfileEvent extends BaseEvent{

}

class SignOutEvent extends ProfileEvent{
  SignOutEvent();

  @override
  List<Object> get props =>[];

}

class SignOutSuccessEvent extends ProfileEvent{
  SignOutSuccessEvent();

  @override
  List<Object> get props =>[];

}