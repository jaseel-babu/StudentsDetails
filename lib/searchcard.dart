import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_sample/dataModel.dart';
import 'dart:io';

class searchcard extends StatelessWidget {
  const searchcard({
    Key? key,
    required this.data,
    required this.edit,
    required this.index,
    required this.StudentUpdate,
    required this.delete,
  }) : super(key: key);
  final DataModel data;
  final Function edit;
  final int? index;
  final Function delete;
  final Function StudentUpdate;

  @override
  Widget build(BuildContext context) {
    // TextEditingController searchcontroller = TextEditingController();
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Card(
            child: ListTile(
          leading: CircleAvatar(
              child: Image(
            image: AssetImage('assets/images/download.png'),
          )),
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
                  Navigator.push(context,
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
