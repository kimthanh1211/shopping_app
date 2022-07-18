import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:shopping_app/data/datasources/model/rating_model.dart';

class FireBaseDataBaseClass {
  var streamController = StreamController();

  static DatabaseReference ref = FirebaseDatabase.instance.ref();

  static String getRatingProductPath({required String productId}) {
    return "rating_product/${productId}/";
  }
  static String getAccountPath() {
    return "account_list";
  }
  static String getChatMapPath() {
    return "chat_map/";
  }
  // static String getContentChatPath({required String chatId}) {
  //   return "chat_content/$chatId";
  // }
  static String getChatPath({required String chatId}) {
    return "chat/${chatId}/";
  }



  // static Future<List<RatingModel>?> listenerDataRating({required String path}) async {
  //   try{
  //     Completer<List<RatingModel>> completer = Completer();
  //     final ref = FirebaseDatabase.instance.ref(path);
  //     List<RatingModel>? listRate= [];
  //     ref.onValue.listen((event) {
  //       String? accountId, preview;
  //       double? rate;
  //       for (final child in event.snapshot.children) {
  //         //Handle the post.
  //         print("test child value: ${child.value}");
  //         if(child.key == "accountId") accountId = child.value.toString();
  //         else if(child.key == "preview") preview = child.value.toString();
  //         else if(child.key == "rate") rate = double.tryParse(child.value.toString());
  //       }
  //       listRate.add(
  //           RatingModel(accountId, preview, rate)
  //       );
  //       print("add ${listRate.length}");
  //     }, onError: (error) {
  //       // Error.
  //     }).onDone(() {
  //       completer.complete(listRate);
  //       print("complete ${completer.future}");
  //     });
  //     return completer.future;
  //   }
  //   catch(error){
  //     print('Error litener data firebase: ${error}');
  //   }
  //
  // }
  static Future<void> listenerDataFromFireBaseDB({required String path}) async {
    try{
      final ref = FirebaseDatabase.instance.ref(path);
      ref.onChildAdded.listen((event) {
        // A new comment has been added, so add it to the displayed list.
        print("Listener ref onChildAdded: $event");
      });
      ref.onChildChanged.listen((event) {
        // A comment has changed; use the key to determine if we are displaying this
        // comment and if so displayed the changed comment.
        print("Listener ref onChildChanged: $event");
      });
      ref.onChildRemoved.listen((event) {
        // A comment has been removed; use the key to determine if we are displaying
        // this comment and if so remove it.
        print("Listener ref onChildRemoved: $event");
      });
    }
    catch(error){
      print('Error litener data firebase: ${error}');
    }

  }

  static Future<void> pushDataFromFireBaseDB({required String path,required Map<String,Object?> value}) async {
    try{
      DatabaseReference  push =  ref.child(path).push();
      push.set(value);
    }
    catch(error){
      print('Error update data firebase: ${error}');
    }

  }
  static Future<void> updateDataFromFireBaseDB({required String path,required Map<String,Object?> value}) async {
    try{
      ref.child(path).update(value);
    }
    catch(error){
      print('Error update data firebase: ${error}');
    }

  }

  static Future<void> setDataFromFireBaseDB({required String path,required Object value}) async {
    try{
      ref.child(path).set(value);
    }
    catch(error){
      print('Error set data firebase: ${error}');
    }

  }

  static Future<DataSnapshot?> getDataFromFireBaseDB({required String path}) async {
    try{
      final snapshot = await ref.child(path).get();
      if (snapshot.exists) {
        print(snapshot.value);
        return snapshot;
      } else {
        print('No data available.');
        return null;
      }
    }
    catch(error){
      print('Error get data firebase: ${error}');
      return null;
    }
  }
  // static Future<Object?> getDataFromFireBaseDB({required String path}) async {
  //   try{
  //     final snapshot = await ref.child(path).get();
  //     if (snapshot.exists) {
  //       print(snapshot.value);
  //       return snapshot.value;
  //     } else {
  //       print('No data available.');
  //       return null;
  //     }
  //   }
  //   catch(error){
  //     print('Error get data firebase: ${error}');
  //     return null;
  //   }
  // }
}