import 'package:shopping_app/common/base/base_event.dart';

abstract class SignUpEvent extends BaseEvent{

}
class SignUpExecuteEvent extends SignUpEvent{
  late String name, email, phone, password, address;

  SignUpExecuteEvent({
     required this.name
    ,required this.email
    ,required this.phone
    ,required this.password
    ,required this.address
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SignUpSuccessEvent extends SignUpEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}