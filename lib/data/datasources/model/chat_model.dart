import 'dart:ffi';

class ChatModel {
  String email = "";
  String name = "";
  String content = "";
  bool isDefault = false;

  ChatModel({
    required this.email,
    required this.name,
    required this.content,
    required this.isDefault,
  });
}
class ChatMapUserModel{
  String email1 = "";
  String email2 = "";
  String name1 = "";
  String name2 = "";
  String chatId ="";
  ChatMapUserModel({
    required this.email1,
    required this.email2,
    required this.name1,
    required this.name2,
    required this.chatId,
  });
}