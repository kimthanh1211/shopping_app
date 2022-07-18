

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:shopping_app/data/datasources/model/chat_model.dart';
import 'package:shopping_app/data/datasources/model/user_model.dart';
import 'package:shopping_app/data/repositories/chat_repository.dart';

import '../../../common/base/base_bloc.dart';
import '../../../common/base/base_event.dart';
import 'chat_event.dart';

class ChatBloc extends BaseBloc{
  StreamController<List<UserModel>> listUser = StreamController();
  StreamController<List<ChatModel>> listChatContent = StreamController();
  var subscription;
  StreamController<String> message = StreamController();
  late ChatRepository _chatRepository;

  void setRepository({required ChatRepository chatRepository}){
    _chatRepository = chatRepository;
  }

  @override
  void dispatch(BaseEvent event){
    if (event is GetListAccountChatEvent) {
      getListAccount(event);
    }
    else if (event is MapUserChatEvent) {
      mapUserChat(event);
    }
    else if (event is GetListContentChatEvent) {
      getListContentChat(event);
    }
    else if (event is PushChatEvent) {
      pushChat(event);
    }
    else if (event is ListenerChatEvent) {
      listenerChatEvent(event);
    }
  }
  // void listenerRatingEvent(ListenerRatingEvent event){
  //     loadingSink.add(true);
  //     _ratingRepository.listenerRatingProduct(productId: event.productId);
  //     loadingSink.add(false);
  // }

  void listenerChatEvent(ListenerChatEvent event){
       subscription = FirebaseDatabase.instance
          .ref()
          .child('chat/${event.chatId}')
          .onChildAdded
          .listen((eventResponse) {
          print("onChildAdded:$eventResponse");
          getListContentChat(GetListContentChatEvent(chatId: event.chatId,email: event.email));
      });
  }



  void pushChat(PushChatEvent event){
    loadingSink.add(true);
    //print("set data 2: ${event.productId},${event.value}");
    _chatRepository.pushChat(chatId: event.chatId, value: event.value);
    //progressSink.add(GetRatingEvent(productId: event.productId));
    loadingSink.add(false);
  }

  void getListContentChat(GetListContentChatEvent event) async{
    loadingSink.add(true);
    List<ChatModel>? data = await _chatRepository.getListChat(chatId: event.chatId,email: event.email);
    if(data !=null && data.length>0){
      for (final child in data){
        print("data item : ${child.name},${child.email},${child.isDefault},${child.content}");
      }
      listChatContent.sink.add(data);
    }
      //sort createTime desc
    loadingSink.add(false);
  }

  void getListAccount(GetListAccountChatEvent event) async{
    loadingSink.add(true);
    List<UserModel>? data = await _chatRepository.getListAccount();
    if(data !=null && data.length>0){
      String email = event.email;
      data.removeWhere((item) => (item.email == email));
      listUser.sink.add(data);
    }
      //sort createTime desc
    loadingSink.add(false);
  }

  void getIdChat(GetListAccountChatEvent event) async{
    loadingSink.add(true);
    List<UserModel>? data = await _chatRepository.getListAccount();
    if(data !=null && data.length>0){
      String email = event.email;
      data.removeWhere((item) => (item.email == email));
      listUser.sink.add(data);
    }
    //sort createTime desc
    loadingSink.add(false);
  }

  void mapUserChat(MapUserChatEvent event) async{
    loadingSink.add(true);
    //print("set data 2: ${event.productId},${event.value}");
    String? chatId =  await _chatRepository.mapUserChat(email1: event.email1, email2: event.email2);
    //progressSink.add(GetRatingEvent(productId: event.productId));
    progressSink.add(MapUserChatSuccessEvent(chatId: chatId!,email2: event.email2,name1: event.name1,name2: event.name2));
    loadingSink.add(false);
  }

  @override
  void dispose() {
    super.dispose();
    listUser.close();
    message.close();

    subscription.cancel();
  }
}