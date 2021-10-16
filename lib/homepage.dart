import 'package:flutter/material.dart';

import 'package:sqflite_sample/dataModel.dart';
import 'package:sqflite_sample/database.dart';
import 'dataCard.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  // File? image;
  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //     // final imageTemporary = File(image.path);
  //     final imagePermanent = await saveImagePermanently(image.path);
  //     setState(() => this.image = imagePermanent);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image:$e');
  //   }
  // }

  // Future<File> saveImagePermanently(String imagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File('${directory.path}/$name');

  //   return File(imagePath).copy(image.path);
  // }

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController standerdController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  List<DataModel> datas = [];
  bool fetching = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text("Student Details"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
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
                // buildsearch(),
                Expanded(
                  child: ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (context, index) => DataCard(
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

  // Widget buildsearch() =>
  //     SearchWidget(text: "search", onChanged: searchbook, hintText: "Title");
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
            FlutterLogo(
              size: 160,
            ),
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

  Scaffold StudentUpdate() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("Upadate Student Profile"),
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
            Builder(builder: (context) {
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
            })
          ],
        ),
      ),
    );
  }

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

  Padding operateButtons(String buttonName) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Builder(builder: (context) {
              return ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple)),
                  child: Text(buttonName),
                  onPressed: () {
                    DataModel dataLocal = DataModel(
                        name: nameController.text,
                        age: ageController.text,
                        school: schoolController.text,
                        standerd: standerdController.text);
                    db.insertData(dataLocal);
                    dataLocal.id = datas[datas.length - 1].id! + 1;
                    setState(() {
                      datas.add(dataLocal);
                    });
                    nameController.clear();
                    ageController.clear();
                    schoolController.clear();
                    standerdController.clear();

                    Navigator.pop(context);
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => HomePage()));
                  });
            }),
          ),
          Container(
            width: 5.0,
          ),
        ],
      ),
    );
  }

  Padding NameField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Form(
        child: TextFormField(
          controller: controller,
          onChanged: (value) {},
          decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        ),
      ),
    );
  }

  void editing(index) {
    currentIndex = index;
    nameController.text = datas[index].name!;
    ageController.text = datas[index].age!;
    schoolController.text = datas[index].school!;
    standerdController.text = datas[index].standerd!;
    StudentUpdate();
  }

  void delete(int index) {
    db.delete(datas[index].id!);
    datas.removeAt(index);
    setState(() {});
  }

  void searchbook(String value) {}
}
