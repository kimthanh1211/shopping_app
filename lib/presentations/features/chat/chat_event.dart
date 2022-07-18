import 'package:shopping_app/common/base/base_event.dart';

abstract class ChatEvent extends BaseEvent {}


class GetListAccountChatEvent extends ChatEvent {
  String email;
  GetListAccountChatEvent({required this.email});

  @override
  List<Object?> get props => [];
}

class PushChat extends ChatEvent {
  String email;
  String name;
  String content;
  PushChat({required this.email,required this.name,required this.content});

  @override
  List<Object?> get props => [];
}

class MapUserChatEvent extends ChatEvent {
  String email1;
  String email2;
  String name1;
  String name2;
  MapUserChatEvent({required this.email1,required this.email2,required this.name1,required this.name2});

  @override
  List<Object?> get props => [];
}

class GetListContentChatEvent extends ChatEvent {
  String chatId;
  String email;
  GetListContentChatEvent({required this.chatId,required this.email});

  @override
  List<Object?> get props => [];
}
class MapUserChatSuccessEvent extends ChatEvent {
  String chatId;
  String email2;
  String name1;
  String name2;
  MapUserChatSuccessEvent({required this.chatId,required this.email2,required this.name1,required this.name2});

  @override
  List<Object?> get props => [];
}

class PushChatEvent extends ChatEvent{
  String chatId;
  Map<String,Object> value;
  PushChatEvent({required this.chatId,required this.value});

  @override
  List<Object> get props =>[];

}
class ListenerChatEvent extends ChatEvent{
  String chatId;
  String email;
  ListenerChatEvent({required this.chatId,required this.email});

  @override
  List<Object> get props =>[];

}
