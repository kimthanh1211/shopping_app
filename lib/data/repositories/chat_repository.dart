import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/datasources/model/chat_model.dart';

import '../datasources/local/firebase/database/firebase_db.dart';
import '../datasources/model/user_model.dart';


class ChatRepository{
  void pushChat({required String chatId,required Map<String,Object?> value}){
    String path = FireBaseDataBaseClass.getChatPath(chatId: chatId);
    FireBaseDataBaseClass.pushDataFromFireBaseDB(path: path, value: value);
  }

  Future<String?> mapUserChat({required String email1,required String email2}) async{
    String path = FireBaseDataBaseClass.getChatMapPath();
    String? chatID = null;
    DataSnapshot? data = await FireBaseDataBaseClass.getDataFromFireBaseDB(path: path);
    if(data!=null &&  data.children !=null && data.children.length>0){
      for (final child in data.children) {
        //Handle the post.
        if(child!=null){
          //print("check bool.hasEnvironment(child.child(email1).value.toString()${child.child(email1).value.toString()}");
          //print("check bool.hasEnvironment(child.child(email2).value.toString()${child.child(email2).value.toString()}");
          if(child.child(email1).value.toString() == "true"  && child.child(email2).value.toString() == "true"){
            //print("has true");
            chatID=child.child("id_chat").value.toString();
          }
        }
      }
    }
    //ko co ket qua
    if(chatID == null){
      chatID = DateTime.now().microsecondsSinceEpoch.toString();
      Map<String,Object?> value ={
        email1:true,
        email2:true,
        "id_chat": chatID
      };
      FireBaseDataBaseClass.pushDataFromFireBaseDB(path: path, value: value);
    }
    print("chatID${chatID}");
    return chatID;

  }

  Future<List<UserModel>?> getListAccount() async {
    String path = FireBaseDataBaseClass.getAccountPath();
    DataSnapshot? data = await FireBaseDataBaseClass.getDataFromFireBaseDB(path: path);
    print("test data $data");
    List<UserModel> listUser =[];
    if(data!=null &&  data.children !=null && data.children.length>0){
      for (final child in data.children) {
        //Handle the post.
        if(child!=null){

          var user = UserModel(
            email: child.child("email").value.toString(),
            name: child.child("name").value.toString(),
            phone: child.child("phone").value.toString(),
            token: child.child("token").value.toString(),
          );
          // print("rating${rating}");
          listUser.add(user);
          // print("listRating${listRating}");
        }
      }
      print("listUser${listUser}");
    }
    return listUser;
  }

  Future<List<ChatModel>?> getListChat({required String chatId,required String email}) async {
    String path = FireBaseDataBaseClass.getChatPath(chatId: chatId);
    DataSnapshot? data = await FireBaseDataBaseClass.getDataFromFireBaseDB(path: path);
    print("test data $data");
    List<ChatModel> listChat =[];
    if(data!=null &&  data.children !=null && data.children.length>0){
      for (final child in data.children) {
        //Handle the post.
        if(child!=null){

          var user = ChatModel(
            email: child.child("email").value.toString(),
            name: child.child("name").value.toString(),
            content: child.child("content").value.toString(),
            isDefault: (child.child("email").value.toString() == email.split("@")[0]),
          );
          // print("rating${rating}");
          listChat.add(user);
          // print("listRating${listRating}");
        }
      }
      print("listChat${listChat.length}");
    }
    return listChat;
  }
}