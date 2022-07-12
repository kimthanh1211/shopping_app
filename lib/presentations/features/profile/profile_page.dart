import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/common/constants/variable_constant.dart';
import 'package:shopping_app/common/widgets/loading_widget.dart';
import 'package:shopping_app/common/widgets/progress_listener_widget.dart';
import 'package:shopping_app/data/datasources/local/cache/app_cache.dart';
import 'package:shopping_app/data/datasources/model/user_model.dart';
import 'package:shopping_app/presentations/features/profile/profile_event.dart';

import '../../../common/base/base_widget.dart';
import '../../../data/datasources/remote/user_response.dart';
import '../../../data/repositories/authentication_repository.dart';
import 'profile_bloc.dart';
import 'profile_event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context)=>AuthenticationRepository()),
        ProxyProvider<AuthenticationRepository,ProfileBloc>(
            create: (context)=>ProfileBloc(),
            update:(context,repository,bloc){
              bloc!.setAuthenticationRepository(authenticationRepository: repository);
              return bloc;
            }
        )
      ],
      appBar: AppBar(title: Text("Thông tin tài khoản")),
      child: ProfilePageContainer(),
    );
  }
}

class ProfilePageContainer extends StatefulWidget {
  const ProfilePageContainer({Key? key}) : super(key: key);

  @override
  State<ProfilePageContainer> createState() => _ProfilePageContainerState();
}

class _ProfilePageContainerState extends State<ProfilePageContainer> {
  late ProfileBloc _bloc;
  late String strAccountInfo,_accountEmail,_accountName,_accountPhone;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read();
    strAccountInfo = AppCache.getString(VariableConstant.ACCOUNT_INFO);
    Map<String, dynamic> user = jsonDecode(strAccountInfo);
    _accountEmail=user['email'];
    _accountName=user['name'];
    _accountPhone=user['phone'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      LoadingWidget(
        bloc: _bloc,
        child: ProgressListenerWidget<ProfileBloc>(
          callback: (event){
            print(event.runtimeType);
            if(event is SignOutSuccessEvent){
              Navigator.pushReplacementNamed(context, "/sign-in");
            }
          },
          child: Column(
            children: [
              Expanded(
                  child: Column(
                    children:[
                      Padding(
                          padding: EdgeInsets.all(50),
                          child: Image.asset("assets/images/avatar.png")
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tên:",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                  width: 350,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ))),
                                  child: Row(children: [
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {

                                            },
                                            child: Text(
                                              _accountName,
                                              style: TextStyle(fontSize: 16, height: 1.4),
                                            ))),
                                    // Icon(
                                    //   Icons.keyboard_arrow_right,
                                    //   color: Colors.grey,
                                    //   size: 40.0,
                                    // )
                                  ]))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                  width: 350,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ))),
                                  child: Row(children: [
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {

                                            },
                                            child: Text(
                                              _accountEmail,
                                              style: TextStyle(fontSize: 16, height: 1.4),
                                            ))),
                                    // Icon(
                                    //   Icons.keyboard_arrow_right,
                                    //   color: Colors.grey,
                                    //   size: 40.0,
                                    // )
                                  ]))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Số điện thoại",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                  width: 350,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ))),
                                  child: Row(children: [
                                    Expanded(
                                        child: TextButton(
                                            onPressed: () {

                                            },
                                            child: Text(
                                              _accountPhone,
                                              style: TextStyle(fontSize: 16, height: 1.4),
                                            ))),
                                    // Icon(
                                    //   Icons.keyboard_arrow_right,
                                    //   color: Colors.grey,
                                    //   size: 40.0,
                                    // )
                                  ]))
                            ],
                          )),
                    ]

                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                        _bloc.eventSink.add(SignOutEvent());
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.red)),
                    child: Text("Log out",
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                  )),
            ],
          ),
        ),
      )
    );
  }
}

