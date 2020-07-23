import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _dueDate = new DateTime.now();
  String _dateText = '';
  String newTask = '';
  String jumlah = '';
  String note = '';

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addData() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('task');
      await reference.add({
        "email": widget.email,
        "jenis": newTask,
        "duedate": _dateText,
        "jumlah": jumlah,
        "note": note,
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/nav.png"), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Aplikasi Keuangan",
                  style: new TextStyle(
                      color: Colors.black45,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                      fontFamily: "atomicage"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "ADD DATA",
                    style: new TextStyle(fontSize: 24.0, color: Colors.black45),
                  ),
                ),
                Icon(
                  Icons.view_list,
                  color: Colors.black45,
                  size: 30.0,
                )
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.dashboard),
                hintText: "Jenis Pengeluaran / Tabungan",
                border: InputBorder.none,
              ),
              style: new TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: new Icon(Icons.date_range),
                ),
                new Expanded(
                  child: Text(
                    "Date",
                    style: new TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ),
                new FlatButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(
                    _dateText,
                    style: new TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  jumlah = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: "Jumlah Pengeluaran",
                border: InputBorder.none,
              ),
              style: new TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  note = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.note),
                hintText: "Note",
                border: InputBorder.none,
              ),
              style: new TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 40.0,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      _addData();
                    }),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 40.0,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
