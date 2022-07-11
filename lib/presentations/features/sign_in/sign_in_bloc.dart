import 'dart:async';
import 'package:shopping_app/common/base/base_bloc.dart';
import 'package:shopping_app/common/base/base_event.dart';
import 'package:shopping_app/common/constants/variable_constant.dart';
import 'package:shopping_app/data/datasources/local/cache/app_cache.dart';
import 'package:shopping_app/data/datasources/model/user_model.dart';
import 'package:shopping_app/data/repositorys/authentication_repository.dart';
import 'package:shopping_app/presentations/features/sign_in/sign_in_event.dart';

class SignInBloc extends BaseBloc{
  StreamController<UserModel> userModelController = StreamController();
  StreamController<String> message = StreamController();
  late AuthenticationRepository _authenticationRepository;
  late AppCache _appCache;

  void setAuthenticationRepository({required AuthenticationRepository authenticationRepository}){
    _authenticationRepository = authenticationRepository;
  }


  @override
  void dispatch(BaseEvent event){
    if(event is LoginEvent){
      _executeLogin(event);
    }
  }

  void _executeLogin(LoginEvent event){
    loadingSink.add(true);
    _authenticationRepository.login(email: event.email,password: event.password)
    .then((userResponse){
      if(userResponse != null ){
        userModelController.sink.add(
            UserModel(
                email: userResponse.email ?? ""
                , name: userResponse.name ?? ""
                , phone: userResponse.phone ?? ""
                , token: userResponse.token ?? ""
            )
        );
        AppCache.setString(key:VariableConstant.TOKEN, value:userResponse.token!);
        progressSink.add(LoginSuccessEvent());
      }
      else message.sink.add("Data repsonse null");
    })
    .catchError((error){
      message.sink.add(error);
    })
    .then((value){ loadingSink.add(false);})
    ;
  }

  @override
  void dispose() {
    super.dispose();
    userModelController.close();
  }
}