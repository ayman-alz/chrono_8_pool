import 'package:chrono_pool/components/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/linksApi.dart';
import '../model/note.dart';

class Cards extends StatelessWidget {
  final void Function()? ontap;
  final NoteModel noteModel;
  final String title;
  final String content;
  final void Function()? onDelete;
static Future<void> saveImage(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("imgSelect", url);
  }

  const Cards(
      {super.key,
      this.ontap,
      required this.title,
      required this.content,
      this.onDelete,
      required this.noteModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: ontap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "$linkImageRoot/${noteModel.noteImage}",
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text("${noteModel.noteTitle}"),
                subtitle: Text("${noteModel.noteContent}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: onDelete,
                    ),
                    IconButton(
                      icon: Icon(Icons
                          .check_circle), // Replace 'another_icon' with the icon you want
                      onPressed: () {
                        print("object");
                        print("=========================================");
                        print("$linkImageRoot/${noteModel.noteImage}");
                      print("=========================================");

            saveImage(
                            "$linkImageRoot/${noteModel.noteImage}");
                        print("$linkImageRoot/${noteModel.noteImage}");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
