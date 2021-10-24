import 'package:flutter/material.dart';
import 'package:recipe_app/controller/bookmark_manager.dart';
import 'package:recipe_app/model/recipe_model.dart';

//TODO: GET ALL BOOKMARKED RECIPES
//TODO: DELETE RECIPE

class BookmarkView extends StatefulWidget {
  const BookmarkView({ Key? key }) : super(key: key);

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  final BookmarkManager _bookmarkManager = BookmarkManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
      ),
      body: FutureBuilder<List<RecipeModel>>(
        future: _bookmarkManager.getAllBookmarks(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting && snapshot.data == null){
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18, color: Colors.red[400])
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index){
              return ListTile(
                leading: Image.network(
                  snapshot.data![index].image, width: 150, height: 150,
                ),
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].category),
                trailing: GestureDetector(
                  onTap: () => _bookmarkManager.deleteBookmark(snapshot.data![index].id),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              );
            }, 
            separatorBuilder: (context, index) => const Divider(), 
            itemCount: snapshot.data!.length
          );
      })
    );
  }
}