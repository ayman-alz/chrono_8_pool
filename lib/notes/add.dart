import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chrono_pool/main.dart';
import '../components/applocal.dart';
import '../components/crud.dart';
import '../constants/linksApi.dart';
import '../decoration/custom_text_form.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  File? myfile;

  final Crud _crud = Crud();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false;

  addNotes() async {
    if (myfile == null)
      return AwesomeDialog(
          context: context,
          title: "${getLang(context, "important")}",
          body: Text("${getLang(context, "please_add_the_photo")}"))
        ..show();
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequestWithFile(
          linkAddNote,
          {
            "title": title.text,
            "content": content.text,
            "id": sharedPref.getString("id")
          },
          myfile!);
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("photo");
      } else {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${getLang(context, "Add_photos")}"),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              CustomTextForm(
                  hint: "${getLang(context, "title")}",
                  savecontroller: title,
                  valid: (val) {
                    //return validInput(val!, 1, 40);
                  }),
              CustomTextForm(
                  hint: "${getLang(context, "content")}",
                  savecontroller: content,
                  valid: (val) {
                    // return validInput(val!, 1, 255);
                  }),
              Container(height: 20),
              MaterialButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${getLang(context, "choose_image")}",
                                    style: TextStyle(fontSize: 25)),
                              ),
                              InkWell(
                                onTap: () async {
                                  XFile? xfile = await ImagePicker()
                                      .pickImage(
                                      source: ImageSource.gallery);
                                  Navigator.of(context).pop();
                                  myfile = File(xfile!.path);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "${getLang(context, "from_gallery")}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  XFile? xfile = await ImagePicker()
                                      .pickImage(
                                      source: ImageSource.camera);
                                  Navigator.of(context).pop();

                                  myfile = File(xfile!.path);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "${getLang(context, "from_camera")}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          )));
                },
                child: Text("${getLang(context, "choose_image")}"),
                textColor: Colors.white,
                color: myfile == null ? Colors.blue : Colors.green,
              ),
              Container(height: 20),
              MaterialButton(
                onPressed: () async {
                  await addNotes();
                },
                child: Text("${getLang(context, "add")}"),
                textColor: Colors.white,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
