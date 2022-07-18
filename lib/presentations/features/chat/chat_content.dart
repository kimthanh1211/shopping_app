import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/datasources/model/chat_model.dart';

import '../../../common/base/base_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/repositories/chat_repository.dart';
import 'chat_bloc.dart';
import 'chat_event.dart';

class ChatContentPage extends StatefulWidget {
  const ChatContentPage({Key? key}) : super(key: key);

  @override
  _ChatContentPageState createState() => _ChatContentPageState();
}

class _ChatContentPageState extends State<ChatContentPage> {
  ChatMapUserModel? chatMapUserModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var dataReceive = ModalRoute.of(context)?.settings.arguments as Map;
    chatMapUserModel =dataReceive["chatMapUser"];
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
          title: Text(chatMapUserModel?.name2 ?? ""),
        ),
        child:ChatContentPageContainer()
    );
  }
}

class ChatContentPageContainer extends StatefulWidget {
  const ChatContentPageContainer({Key? key}) : super(key: key);

  @override
  State<ChatContentPageContainer> createState() => _ChatContentPageContainerState();
}

class _ChatContentPageContainerState extends State<ChatContentPageContainer> {
  ChatMapUserModel? chatMapUserModel;
  late ChatBloc chatBloc;
  final _sendController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var dataReceive = ModalRoute.of(context)?.settings.arguments as Map;
    chatMapUserModel =dataReceive["chatMapUser"];
    print("chatMapUserModel: ${chatMapUserModel!.chatId},${chatMapUserModel!.email1},${chatMapUserModel!.email2},${chatMapUserModel!.name1},${chatMapUserModel!.name2}");

    chatBloc= context.read();
    chatBloc.eventSink.add(GetListContentChatEvent(chatId: chatMapUserModel!.chatId,email: chatMapUserModel!.email1));

    chatBloc.eventSink.add(ListenerChatEvent(chatId: chatMapUserModel!.chatId,email: chatMapUserModel!.email1));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingWidget(
        bloc: chatBloc,
        child: ProgressListenerWidget<ChatBloc>(
          callback: (event){
            print(event.runtimeType);
            if(event is PushChat){

            }
          },
          child: StreamBuilder<List<ChatModel>>(
              initialData: null,
              stream: chatBloc.listChatContent.stream,
              builder:(context, snapshot){
                print("test snapshot.data${snapshot.data}");
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Data is error"),
                  );
                }
                // if (snapshot.data == null || snapshot.data!.isEmpty) {
                //   return Center(
                //     child: Text("Data is empty"),
                //   );
                // }
                return Column(
                  children:[
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ??0,
                          itemBuilder: (context, index) {
                            return ChatBubble(
                              text: snapshot.data![index].content,
                              isCurrentUser: snapshot.data![index].isDefault,
                            );
                          }
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children:[
                          Expanded(
                            flex:5,
                            //margin: EdgeInsets.only(left: 10, right: 10),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: TextField(
                                maxLines: 1,
                                controller: _sendController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  hintText: "Nhập tin nhắn...",
                                  labelStyle: TextStyle(color: Colors.blue),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(width: 0, color: Colors.black12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(width: 0, color: Colors.black12)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(width: 0, color: Colors.black12)),
                                  //prefixIcon: Icon(Icons.email, color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                String _msg = _sendController.text.toString();
                                if (_msg.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chưa nhập nội dung chat",style: TextStyle(color:Colors.red),)));
                                  return;
                                }
                                Map<String,Object> value = {
                                  "email":chatMapUserModel!.email1,
                                  "name":chatMapUserModel!.name1,
                                  "content":_msg,
                                  "createTime":DateTime.now().toString(),
                                };
                                chatBloc.eventSink.add(PushChatEvent(chatId: chatMapUserModel!.chatId,value: value));
                                _sendController.clear();
                              },
                              icon: Icon(Icons.send,color: Colors.blue,size: 38)
                            ),
                          ),
                        ]
                      ),
                    ),
                  ]
                );
              }
          ),
        ),
      ),
    );
  }
}

Widget _buildListView(){
  return ListView(
    children: const [
      ChatBubble(
        text: 'How was the concert?',
        isCurrentUser: false,
      ),
      ChatBubble(
        text: 'Awesome! Next time you gotta come as well!',
        isCurrentUser: true,
      ),
      ChatBubble(
        text: 'Ok, when is the next date?',
        isCurrentUser: false,
      ),
      ChatBubble(
        text: 'They\'re playing on the 20th of November',
        isCurrentUser: true,
      ),
      ChatBubble(
        text: 'Let\'s do it!',
        isCurrentUser: false,
      ),
    ],
  );

}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}