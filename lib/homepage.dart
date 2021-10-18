import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_sample/dataModel.dart';
import 'package:sqflite_sample/database.dart';
import 'package:sqflite_sample/searchcard.dart';
import 'dataCard.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'search.dart';
import 'searchcard.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController standerdController = TextEditingController();

  TextEditingController searchcontroller = TextEditingController();
  List<DataModel> datas = [];
  List<DataModel> searchresults = [];
  bool fetching = true;
  String? search;

  late DB db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB();
    getData();
  }

  void getData() async {
    datas = await db.getData();
    setState(() {
      fetching = false;
    });
  }

  searchmethod(index) async {
    searchresults = await db.searchdata(search!);
    // datas = await db.searchdata(search!);
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text("Student Details"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => searchpage(),
                  ),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[300],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddStudent()));
        },
      ),
      body: fetching
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (context, index) => searchcard(
                      data: datas[index],
                      edit: editing,
                      index: index,
                      StudentUpdate: StudentUpdate,
                      delete: delete,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Scaffold AddStudent() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("Add new Student"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [
            NameField(nameController, 'Student Name'),
            NameField(ageController, 'Age'),
            NameField(schoolController, 'Place'),
            NameField(standerdController, 'Standerd'),
            buildButtons(
              "Pick Image",
              Icons.image_outlined,
              () {},
            ),
            SizedBox(
              height: 10,
            ),
            buildButtons(
              "Camera",
              Icons.image_outlined,
              () {},
            ),
            operateButtons('Save'),
          ],
        ),
      ),
    );
  }

//Student Updatepage

  Scaffold StudentUpdate() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("Update Student Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [
            NameField(nameController, 'Student Name'),
            NameField(ageController, 'Age'),
            NameField(schoolController, 'Place'),
            NameField(standerdController, 'Standerd'),
            buildButtons(
              "Pick Image",
              Icons.image_outlined,
              () {},
            ),
            SizedBox(
              height: 10,
            ),
            buildButtons(
              "Camera",
              Icons.image_outlined,
              () {},
            ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      DataModel newData = datas[currentIndex];
                      newData.standerd = standerdController.text;
                      newData.school = schoolController.text;
                      newData.age = ageController.text;
                      newData.name = nameController.text;

                      db.update(newData, newData.id!);
                      nameController.clear();
                      ageController.clear();
                      schoolController.clear();
                      standerdController.clear();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text("Update"));
              },
            ),
          ],
        ),
      ),
    );
  }
//******************************/

  ElevatedButton buildButtons(
      String buttonName, IconData icons, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(56),
        primary: Colors.grey[300],
        onPrimary: Colors.black,
        textStyle: TextStyle(fontSize: 20),
      ),
      onPressed: onClicked,
      child: Row(
        children: [
          Icon(icons),
          SizedBox(
            width: 20,
          ),
          Text(buttonName),
        ],
      ),
    );
  }

//************************************/

  Padding operateButtons(String buttonName) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                  ),
                  child: Text(buttonName),
                  onPressed: () {
                    DataModel dataLocal = DataModel(
                      name: nameController.text,
                      age: ageController.text,
                      school: schoolController.text,
                      standerd: standerdController.text,
                    );
                    db.insertData(dataLocal);
                    dataLocal.id = datas[datas.length - 1].id! + 1;
                    setState(
                      () {
                        datas.add(dataLocal);
                      },
                    );
                    nameController.clear();
                    ageController.clear();
                    schoolController.clear();
                    standerdController.clear();

                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Container(
            width: 5.0,
          ),
        ],
      ),
    );
  }

//**************************************/

  Padding NameField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Form(
        child: TextFormField(
          controller: controller,
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

//*******************************/

  void editing(index) {
    currentIndex = index;
    nameController.text = datas[index].name!;
    ageController.text = datas[index].age!;
    schoolController.text = datas[index].school!;
    standerdController.text = datas[index].standerd!;

    StudentUpdate();
  }

//*************************************/
  void delete(int index) {
    db.delete(datas[index].id!);
    datas.removeAt(index);

    setState(() {});
  }

//*************************************/

  Scaffold searchpage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search "),
        backgroundColor: Colors.purple[300],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: searchcontroller,
                  onChanged: (value) {
                    search = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Search Here'),
                ),
              ),
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => searchpage()));

                    searchmethod(searchresults);
                  },
                  child: Text('search'),
                );
              }),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: searchresults.length,
                itemBuilder: (context, index) => searchcard(
                  data: searchresults[index],
                  edit: editing,
                  index: index,
                  StudentUpdate: StudentUpdate,
                  delete: delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
