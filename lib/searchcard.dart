import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite_sample/dataModel.dart';

class searchcard extends StatelessWidget {
  const searchcard(
      {Key? key,
      required this.data,
      required this.edit,
      required this.index,
      required this.StudentUpdate,
      required this.delete,
      required this.img64})
      : super(key: key);
  final DataModel data;
  final Function edit;
  final int? index;
  final Function delete;
  final Function StudentUpdate;
  final String img64;

  @override
  Widget build(BuildContext context) {
    print(img64);

    dynamic img = data.img64;

    // TextEditingController searchcontroller = TextEditingController();
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Card(
            child: ListTile(
          leading: Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: img == null || img == ""
                ? Image.asset('assets/images/download.png')
                : Image.memory(
                    base64Decode(img),
                  ),
          ),
          title: GestureDetector(
              child: Text(data.name!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => studentProfile()),
                );
              }),
          subtitle: Text('Click to see his Profile'),
          trailing: CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                delete(index);
              },
            ),
          ),
        )),
      ],
    );
  }

  Scaffold studentProfile() {
    dynamic img = data.img64;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Builder(builder: (context) {
            return CircleAvatar(
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  edit(index);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => StudentUpdate()));
                },
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.purple[50],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("PHOTO"),
                      SizedBox(
                        height: 10,
                      ),
                      img == null || img == ""
                          ? Image.asset('assets/images/download.png')
                          : Image.memory(
                              base64Decode(img),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("NAME"),
                      Card(
                        child: ListTile(
                          title: Text(data.name!),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Age"),
                      Card(
                        child: ListTile(
                          title: Text(data.age!),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("PLACE"),
                      Card(
                        child: ListTile(
                          title: Text(data.school!),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Class"),
                      Card(
                        child: ListTile(
                          title: Text(data.standerd! + 'th Standerd'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
