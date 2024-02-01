import 'package:flutter/material.dart';
import 'package:chrono_pool/main.dart';

import '../components/applocal.dart';
import '../components/cards.dart';
import '../components/crud.dart';
import '../constants/linksApi.dart';
import '../model/note.dart';
import '../notes/edit.dart';


class Photo extends StatefulWidget {
  const Photo({super.key});

  @override
  State<Photo> createState() => _HomeState();
}

class _HomeState extends State<Photo> {
  final Crud _crud = Crud();

  getNote() async {
    var response = await _crud.postRequest(linkViewNote, {
      "id": sharedPref.getString("id") ,
    });


    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( leading:IconButton(onPressed: () {
        Navigator.of(context).pop();
      }, icon: const Icon(Icons.arrow_back)) ,
        title:  Text("${getLang(context, "photos")}"),
        actions: [
          IconButton(onPressed: () {
            sharedPref.clear();
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnote");
        },
        child:  Icon(Icons.add) ,
      ),
      body: Container(
        padding:  EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: getNote(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == 'success') {
                    return ListView.builder(
                      itemCount: snapshot.data['data'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Cards(
                          onDelete: () async {
                            var response = await _crud.postRequest (linkDeleteNote , {
                              "id" : snapshot.data['data'][i]['note_id'].toString(),
                              "imagename" : snapshot.data['data'][i]['note_image'].toString()
                            }) ;
                            setState(() {

                            });

                            if (response['status']== ['success'] ) {
                              Navigator.of(context).pushReplacementNamed("home");
                            }


                          } ,
                          ontap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder:
                                (context) => EditNote(notes:snapshot.data['data'][i] ,) ));
                          },
                          noteModel : NoteModel.fromJson(snapshot.data['data'][i]), title: '', content: '',

                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "${getLang(context, "failed_photos")}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("${getLang(context, "loading")}"));
                }

                return Center(child: Text("${getLang(context, "loading")}"));
              },
            ),
          ],
        ),
      ),
    );
  }
}





class Photo2 extends StatefulWidget {
  const Photo2({super.key});

  @override
  State<Photo2> createState() => _Photo2State();
}

class _Photo2State extends State<Photo2> {
  final Crud _crud = Crud();

  getNote() async {
    var response = await _crud.postRequest(linkViewNote, {
      "id": sharedPref.getString("id") ,
    });


    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        centerTitle: true,
        title: Text("Photos",style: TextStyle(fontSize: 25),), 
      //   leading:IconButton(onPressed: () {
      //   Navigator.of(context).pop();
      // }, icon: const Icon(Icons.arrow_back)) ,
   //     title:  Text("${getLang(context, "photos")}"),
        actions: [
          IconButton(onPressed: () {
            sharedPref.clear();
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnote");
        },
        child:  Icon(Icons.add) ,
      ),
      body: Container(
        padding:  EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: getNote(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == 'success') {
                    return ListView.builder(
                      itemCount: snapshot.data['data'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Cards(
                          onDelete: () async {
                            var response = await _crud.postRequest (linkDeleteNote , {
                              "id" : snapshot.data['data'][i]['note_id'].toString(),
                              "imagename" : snapshot.data['data'][i]['note_image'].toString()
                            }) ;
                            setState(() {

                            });

                            if (response['status']== ['success'] ) {
                              Navigator.of(context).pushReplacementNamed("home");
                            }


                          } ,
                          ontap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder:
                                (context) => EditNote(notes:snapshot.data['data'][i] ,) ));
                          },
                          noteModel : NoteModel.fromJson(snapshot.data['data'][i]), title: '', content: '',

                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "${getLang(context, "failed_photos")}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("${getLang(context, "loading")}"));
                }

                return Center(child: Text("${getLang(context, "loading")}"));
              },
            ),
          ],
        ),
      ),
    );
  }
}

