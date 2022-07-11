import 'dart:async';

import '../../../common/base/base_bloc.dart';
import '../../../common/base/base_event.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../../data/datasources/model/user_model.dart';
import '../../../data/repositories/authentication_repository.dart';
import 'profile_event.dart';


class ProfileBloc extends BaseBloc{
  StreamController<UserModel> userModelController = StreamController();
  StreamController<String> message = StreamController();
  late AuthenticationRepository _authenticationRepository;
  late AppCache _appCache;

  void setAuthenticationRepository({required AuthenticationRepository authenticationRepository}){
    _authenticationRepository = authenticationRepository;
  }


  @override
  void dispatch(BaseEvent event){
    if(event is SignOutEvent){
      _executeSignOut(event);
    }
  }

  void _executeSignOut(SignOutEvent event){
    loadingSink.add(true);
    AppCache.clearAll();
    progressSink.add(SignOutSuccessEvent());
    loadingSink.add(false);
    ;
  }

  @override
  void dispose() {
    super.dispose();
    userModelController.close();
  }
}