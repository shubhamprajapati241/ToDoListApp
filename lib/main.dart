import 'package:flutter/material.dart';
import 'package:to_do_list/todoui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData.dark().copyWith(
        accentColor : Colors.purple,
      ),
      
      home: ToDoUi(),
    );
  }
}
