import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:recipe_app/service/bookmark_recipe.dart';
import 'package:recipe_app/model/recipe_model.dart';

class BookmarkManager with ChangeNotifier {
  String _feedback = "";
  final BookmarkService _bookmarkService = BookmarkService();

  setFeedback(String feedback){
    _feedback = feedback;
    notifyListeners();
  }

  get getFeedback => _feedback;

  Future<List<RecipeModel>> getAllBookmarks() async{
    List<RecipeModel>? _bookmarks;
    await _bookmarkService.open();
    await _bookmarkService.getAllRecipe()
    .then((value){
      if(value == null){
        _bookmarks = [];
      }else{
        _bookmarks = value;
      }
    }).catchError((onError){
      debugPrint('get err: $onError');
      _bookmarks = [];
    });
    await _bookmarkService.close();
    return _bookmarks!;
  }

  // addBookmark(RecipeModel recipeModel) async {
  //   try {
  //     await _bookmarkService.open();
  //     await _bookmarkService.insert(recipeModel);
  //     await getAllBookmarks();
  //     await _bookmarkService.close();
  //   } catch (error) {
  //     setFeedback("$error");
  //   }
  // }

  Future<bool> addBookmark(RecipeModel model)async{
    bool isAdded = false;
    await _bookmarkService.open();
    await _bookmarkService.insert(model).then((value){
      setFeedback('Bookmark added succesfully');
      isAdded = true;
    }).catchError((onError){
      debugPrint('err: $onError');
      setFeedback('$onError');
      isAdded = false;
    });
    await _bookmarkService.close();
    return isAdded;
  }  

  Future<bool> deleteBookmark(int? id)async{
    debugPrint('deleting...');
    bool isDeleted = false;
    await _bookmarkService.open();
    await _bookmarkService.delete(id!).then((_){
      isDeleted = true;
      setFeedback('Bookmark added succesfully');
    }).catchError((onError){
      isDeleted = false;
      setFeedback('$onError');
    });
    await _bookmarkService.close();
    return isDeleted;
  }
}