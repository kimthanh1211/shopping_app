import 'dart:async';

import 'package:shopping_app/common/base/base_bloc.dart';
import 'package:shopping_app/common/base/base_event.dart';
import 'package:shopping_app/data/datasources/model/user_model.dart';
import 'package:shopping_app/data/repositories/authentication_repository.dart';
import 'package:shopping_app/presentations/features/sign_up/sign_up_event.dart';

class SignUpBloc extends BaseBloc{
  StreamController<UserModel> userModelController = StreamController();
  StreamController<String> message = StreamController();
  late AuthenticationRepository _authenticationRepository;

  void setAuthenticationRepository({required AuthenticationRepository authenticationRepository}){
    _authenticationRepository = authenticationRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    if(event is SignUpExecuteEvent){
      _executeSignUp(event);
    }
  }

  @override
  void dispose() {
    super.dispose();
    userModelController.close();
    message.close();
  }

  void _executeSignUp(SignUpExecuteEvent event){
    loadingSink.add(true);
    _authenticationRepository
        .register(
        email: event.email,
        password: event.password,
        name: event.name,
        address: event.address,
        phone: event.phone)
        .then((userResponse) {
      userModelController.sink.add(UserModel(
          email: userResponse.email ?? "",
          name: userResponse.name ?? "",
          phone: userResponse.phone ?? "",
          token: userResponse.token ?? ""));
      progressSink.add(SignUpSuccessEvent());
    }).catchError((error) {
      message.sink.add(error);
    }).whenComplete((){ loadingSink.add(false);});
  }


}

