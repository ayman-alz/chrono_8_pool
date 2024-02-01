import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/crud.dart';
import '../constants/linksApi.dart';
import '../decoration/custom_text_form.dart';
import '../main.dart';

class EditNote extends StatefulWidget {
  final notes ;
  const EditNote({super.key, this.notes});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  final Crud _crud = Crud();

  GlobalKey<FormState> formstate = GlobalKey<FormState>() ;

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false ;


  editnote() async {

    if (formstate.currentState!.validate()) {

      setState(() {
        isLoading = true ;
      });
      var response = await _crud.postRequest(linkEditNote , {
        "title" : title.text ,
        "content" : content.text ,
        "id" : widget.notes['notes_id'].toString()
      });

      setState(() {
        isLoading = false ;
      });
      if (response['status']== ['success']) {
        Navigator.of(context).pushReplacementNamed("home");
      }
      else  {

      }
    }
  }

  @override
  void initState() {
    if (widget.notes != null) {
      title.text = widget.notes['notes_title'] ?? '';
      content.text = widget.notes['notes_content'] ?? '';
    }

    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(appBar:
    AppBar(title:
    Text("Edit note"),
    ),
      body: isLoading == true ?
      Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              CustomTextForm(
                hint: "title",
                savecontroller: title,
                valid: (val) {
                },
              ),
              CustomTextForm(
                hint: "content",
                savecontroller: content,
                valid: (val) {

                },
              ),
              Container(height: 20,),
              MaterialButton(onPressed: ()  async {
                await editnote();
              },
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.blue,
              ),

            ], // Add this square bracket
          ),
        ),
      ),
    );
  }
}
