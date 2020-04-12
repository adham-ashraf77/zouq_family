import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        title: Text("اضافة منتج", style: headers1),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 30),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    //TODO  Call Upload Video method
                  },
                  child: Container(
                    width: 160,
                    height: 100,
                    child: Center(child: Image.asset("assets/icons/video.png")),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'فيديو اختياري',
                      style: TextStyle(fontSize: 23),
                    ),
                    Text(
                      'مسموح بحد اقصى 10 ثواني',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'صور للمنتج',
                  style: TextStyle(fontSize: 23),
                ),
                Text(
                  'اجبارى-بحد اقصى 5 صور',
                  style: paragarph3,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: InkWell(
                      onTap: () {
                        //TODO  Call Upload Image method
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        child: Center(
                            child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.grey,
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black, width: 0.1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'الاسم',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'السعر',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 15),
              child: DropdownButton<String>(
                value: _dropdownValue,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(29, 174, 209, 1),
                  size: 35,
                ),
                elevation: 10,
                hint: Text(
                  "تصنيف المنتج",
                ),
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                isExpanded: true,
                onChanged: (String newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                items: <String>['حلوى', 'مكسرات', 'اطعمه', 'مطبوخات']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                  hintText: 'وصف المنتج',
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 40, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Color.fromRGBO(29, 174, 209, 1),
                ),
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                  child: Text(
                    'اضف',
                    style: TextStyle(color: mainColor, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
