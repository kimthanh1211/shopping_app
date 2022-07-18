import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/datasources/model/chat_model.dart';
import 'package:shopping_app/data/datasources/model/user_model.dart';
import 'package:shopping_app/presentations/features/chat/chat_event.dart';

import '../../../common/base/base_widget.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../../data/repositories/chat_repository.dart';
import '../product_detail/product_detail_bloc.dart';
import 'chat_bloc.dart';

class ChatListAccountPage extends StatefulWidget {
  const ChatListAccountPage({Key? key}) : super(key: key);

  @override
  State<ChatListAccountPage> createState()=> _ChatListAccountPageState();
}

class _ChatListAccountPageState extends State<ChatListAccountPage> {
  late ChatRepository _chatRepository;
  List<UserModel>? listAccount;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
        providers: [
          Provider(create: (context)=>ChatRepository()),
          ProxyProvider<ChatRepository,ChatBloc>(
              create: (context)=>ChatBloc(),
              update:(context,chatRepository,bloc){
                bloc!.setRepository(chatRepository: chatRepository);
                return bloc;
              }
          )
        ],
        appBar: AppBar(
          title: Text("Danh sách chat"),
        ),
        child:ChatListAccountPageContainer()
    );
  }
}

class ChatListAccountPageContainer extends StatefulWidget {
  const ChatListAccountPageContainer({Key? key}) : super(key: key);

  @override
  State<ChatListAccountPageContainer> createState() => _ChatListAccountPageContainerState();
}

class _ChatListAccountPageContainerState extends State<ChatListAccountPageContainer> {
  late ChatBloc chatBloc;
  late String strAccountInfo,_accountEmail,_accountName;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    strAccountInfo = AppCache.getString(VariableConstant.ACCOUNT_INFO);
    Map<String, dynamic> user = jsonDecode(strAccountInfo);
    _accountEmail=user['email']??"";
    _accountName=user['name']??"";

    chatBloc= context.read();
    chatBloc.eventSink.add(GetListAccountChatEvent(email: _accountEmail));

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingWidget(
        bloc: chatBloc,
        child: ProgressListenerWidget<ChatBloc>(
          callback: (event){
            print(event.runtimeType);
            if(event is MapUserChatSuccessEvent){
              Navigator.pushNamed(
                  context,
                  "/chat-content",
                  //arguments:{"chatMapUser": ChatMapUserModel(email1: _accountEmail.split("@")[0],email2: snapshot.data![index].email.split("@")[0])}
                  arguments:{"chatMapUser": ChatMapUserModel(
                      chatId: event.chatId,
                      email1: _accountEmail.split("@")[0],
                      email2: event.email2,
                      name1: event.name1,
                      name2: event.name2
                  )}
              );
            }
          },
          child: StreamBuilder<List<UserModel>>(
              initialData: null,
              stream: chatBloc.listUser.stream,
              builder:(context, snapshot){
                print("test snapshot.data${snapshot.data}");
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Data is error"),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Data is empty"),
                  );
                }
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shadowColor: Colors.blueGrey,
                        child: InkWell(
                          onTap: (){
                            chatBloc.eventSink.add(MapUserChatEvent(
                                email1: _accountEmail.split("@")[0],
                                email2: snapshot.data![index].email.split("@")[0],
                                name1: _accountName,
                                name2: snapshot.data![index].name
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                    child: Image.asset("assets/images/avatar.png",width: 50, height: 50, fit: BoxFit.fill)
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${snapshot.data![index].name}",
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );
              }
          ),
        ),
      ),
    );
  }
}

