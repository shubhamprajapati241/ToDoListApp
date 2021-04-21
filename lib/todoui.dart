import 'package:flutter/material.dart';
import 'package:to_do_list/db_helper.dart';

class ToDoUi extends StatefulWidget {
  @override
  _ToDoUiState createState() => _ToDoUiState();
}

class _ToDoUiState extends State<ToDoUi> {

  final _dbhelper = Databasehelper.instance;

  final _texteditingcontroller = TextEditingController();
  bool validated = true; 
  String errText = "";
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();



  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName : todoedited,
    };

    final id = await _dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated = true;
      errText = "";
    });
  }


  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await _dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(
        Card(
            elevation: 5.0,
            margin : EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical : 5.0,
            ),

            child : Container(
              padding : EdgeInsets.all(5.0),
              child : ListTile(
                title : Text(
                  row['todo'],
                  style : TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Raleway',
                  ),
                  
                ),
                onLongPress: () {
                  _dbhelper.deletedata(row['id']);
                  setState(() {
                    
                  });
                },
              ),
            )  
          )
      );
    });

    return Future.value(true);
  }


  // ? Alert Dialog
  void showalertdialog() {
    _texteditingcontroller.text = "";
    showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                  ),
                title : Text(
                  "Add Tasks",
                  style : TextStyle(
                        fontSize : 20.0,
                        fontFamily: 'Raleway',
                      ),
                ),
              
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _texteditingcontroller,
                      onChanged: (_val) {
                        todoedited = _val;
                      },
                      autofocus: true,
                      style : TextStyle(
                        fontSize : 17.0,
                        fontFamily: 'Raleway',
                      ),
                      decoration: InputDecoration(
                        errorText: validated ? null : errText,
                        errorStyle: TextStyle(
                          fontSize : 14.0,
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top : 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        RaisedButton(
                          color: Colors.purple,
                          onPressed: () {
                            if(_texteditingcontroller.text.isEmpty) {
                              setState(() {
                                errText = "Can't be Empty";
                                validated = false;
                              });
                            }else if(_texteditingcontroller.text.length > 512) {
                              setState(() {
                                errText = "Too many characters";
                                validated = false;
                              });
                            }else {
                              addtodo();
                            }
                          },
                          child: Text("ADD",
                          style : TextStyle(
                            fontSize : 15.0,
                            fontFamily: 'Raleway',
                          ),
                          ),
                        )
                      ],
                    ),
                    )
                  ],
                ),
              );
         });
      }
      );
  }
  
  // // ? mycard widget
  // Widget mycard(String task){
  //   return Card(
  //     elevation: 5.0,
  //     margin : EdgeInsets.symmetric(
  //       horizontal: 10.0,
  //       vertical : 5.0,
  //     ),

  //     child : Container(
  //       padding : EdgeInsets.all(5.0),
  //       child : ListTile(
  //         title : Text(
  //           "$task",
  //           style : TextStyle(
  //             fontSize: 18.0,
  //             fontFamily: 'Raleway',
  //           ),
            
  //         ),
  //         onLongPress: () {
  //           print("Should get deleted");
  //         },
  //       ),
  //     )
      
  //   );
  // }
  
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if(snap.hasData == null) {
          return Center(
            child : Text(
              "No Data",
              style : TextStyle(
                fontSize: 20.0,
                fontFamily: 'Raleway',
                ),
            )
          );
        }else {
          if(myitems.length == 0) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                backgroundColor: Colors.purple,
                child : Icon(
                  Icons.add,
                  color : Colors.white
                ),
              ),
              appBar: AppBar(
                  title : Text("My Tasks",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  backgroundColor: Colors.black,
                  centerTitle: true,
                ),
                backgroundColor: Colors.black,

                body : Center(
                  child : Text(
                    "No Task Available",
                    style : TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Raleway',
                    ),
                    ),
                )
            );
          }else { 
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                backgroundColor: Colors.purple,
                child : Icon(
                  Icons.add,
                  color : Colors.white
                ),
              ),
              appBar: AppBar(
                  title : Text("My Tasks",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  backgroundColor: Colors.black,
                  centerTitle: true,
                ),
                backgroundColor: Colors.black,

                body : SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),),
          );
        }
        }
      },
       future: query(),
      );
}
}


// Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: showalertdialog,
//         backgroundColor: Colors.purple,
//         child : Icon(
//           Icons.add,
//           color : Colors.white
//         ),
//       ),
//       appBar: AppBar(
//         title : Text("My Tasks",
//         style: TextStyle(
//           fontFamily: 'Raleway',
//           fontWeight: FontWeight.bold,
//         ),
//         ),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.black,

//       body : SingleChildScrollView(
//         child : Column(
//           children: <Widget>[
//             mycard("Record a video"),
//             mycard("Go to sleep"),
//             mycard("Add your task here"),
//             mycard("SQL command : \nInsert\nUpdate\nSet\nDelete"),
//             mycard("https://source.unsplash.com/400x400/?sunglass,spects"),
//             mycard("Buy Grocries : \nApple\nMilk\nCorn\nMushroom\nRice"),
//             mycard("CSS Colors : \nMenubar color : Grey #888888 \nNotify color : #565955 \nPrice red color : #ff3939"),
//             mycard("Images hight :\nProduct image size : 240 * 240\nLarge banner size : 1500 * 468 \nslider : 1500 * 535\n"),
//         ],)
//       ),
//     );
 