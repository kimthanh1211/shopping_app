import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:shopping_app/data/datasources/model/rating_model.dart';

import '../datasources/local/firebase/database/firebase_db.dart';


class RatingRepository{
  void pushRatingProduct({required String productId,required Map<String,Object?> value}){
    String path = FireBaseDataBaseClass.getRatingProductPath(productId: productId);
    FireBaseDataBaseClass.pushDataFromFireBaseDB(path: path, value: value);
  }

  Future<List<RatingModel>?> getRatingProduct({required String productId}) async {
    String path = FireBaseDataBaseClass.getRatingProductPath(productId: productId);
    DataSnapshot? data = await FireBaseDataBaseClass.getDataFromFireBaseDB(path: path);
    print("test data $data");
    List<RatingModel> listRating =[];
    if(data!=null &&  data.children !=null && data.children.length>0){
      for (final child in data.children) {
        //Handle the post.
        if(child!=null){
          // print("test child key: ${child.child("rate").value}");
          // print("test child value: ${child.value}");
          // print("test child accountId: ${child.child("accountId").value.toString()}");
          // print("test child preview: ${child.child("preview").value.toString()}");
          // print("test child rate: ${child.child("rate").value.toString()}");

          var rating = RatingModel(
              child.child("accountId").value.toString(),
              child.child("preview").value.toString(),
              double.tryParse(child.child("rate").value.toString()),
              DateTime.tryParse(child.child("createTime").value.toString()),
          );
          // print("rating${rating}");
          listRating.add(rating);
          // print("listRating${listRating}");
        }
      }
      print("listRating${listRating}");
    }
    return listRating;
  }

  // Future<Object?> getRatingProduct({required String productId}) async {
  //   String path = FireBaseDataBaseClass.getRatingProductPath(productId: productId);
  //   Object? data = await FireBaseDataBaseClass.getDataFromFireBaseDB(path: path);
  //   print("test data ${data}");
  //   return data;
  // }

  // void listenerRatingProduct({required String productId}){
  //   String path = FireBaseDataBaseClass.getRatingProductPath(productId: productId);
  //   FireBaseDataBaseClass.listenerDataFromFireBaseDB(path: path);
  // }

}