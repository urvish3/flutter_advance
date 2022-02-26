import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:advance_10_13_14_12/helpers/firebase_auth_helper.dart';
import 'package:advance_10_13_14_12/helpers/firebase_rtdb_helper.dart';
import 'package:advance_10_13_14_12/models/rtdb_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'my_drawer.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final ImagePicker _picker = ImagePicker();
  File? img;
  XFile? xImg;
  List<Student> myAllData = [];
  String data = "";

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      drawer: MyDrawer(args),
      appBar: AppBar(
        title: const Text("DashBoard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () async {
              FirebaseAuthHelper.authHelper.logOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: RTDBHelper.rtdbHelper.stream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Map res = snapshot.data.snapshot.value;

            List items = [];

            res.forEach(
              (key, value) {
                items.add({"key": key, ...value});
              },
            );

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    return Card(
                      margin: const EdgeInsets.all(5),
                      elevation: 3,
                      child: ListTile(
                        isThreeLine: true,
                        leading: fetchProfilePic(items[i]),
                        // leading: Text(items[i]["id"].toString()),
                        title: Text(items[i]["name"]),
                        subtitle: Text(
                            "Age: ${items[i]["age"]}\nKey: ${items[i]['key']}"),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                Map<String, dynamic> newData = {
                                  'name': "Flutter"
                                };
                                await RTDBHelper.rtdbHelper
                                    .update(items[i]['key'], newData);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                await RTDBHelper.rtdbHelper
                                    .delete(items[i]['key']);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              case ConnectionState.done:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text("Insert"),
            icon: const Icon(Icons.add),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Center(
                    child: Text("Pick Image"),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: const CircleAvatar(
                          radius: 60,
                        ),
                        onTap: () async {
                          XFile? xfile = await _picker.pickImage(
                              source: ImageSource.camera);
                          File file = File(xfile!.path);
                          setState(() {
                            img = file;
                            xImg = xfile;
                          });

                          int uid = DateTime.now().millisecond;
                          Uint8List uInt8ListImage = await xImg!.readAsBytes();
                          String base64File = base64Encode(uInt8ListImage);
                          Map data = {
                            'id': 10,
                            'name': "zzzzz",
                            'age': 19,
                            'image': base64File,
                          };
                          RTDBHelper.rtdbHelper.insert(uid, data);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 25,
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text("Fetch"),
            icon: const Icon(Icons.download),
            onPressed: () async {
              data = RTDBHelper.rtdbHelper.fetchAllData();
            },
          ),
        ],
      ),
    );
  }

  Widget fetchProfilePic(Map data) {
    String? img = data['image'];

    Uint8List memoryImg = (img != null) ? base64Decode(img) : Uint8List(0);

    return (data['image'] != null)
        ? CircleAvatar(
            radius: 50,
            backgroundImage: MemoryImage(memoryImg),
          )
        : Text(
            data["id"].toString(),
          );
  }
}
