import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  EditTask({this.jenis, this.duedate, this.jumlah, this.note, this.index});
  final String jenis;
  final DateTime duedate;
  final String jumlah;
  final String note;
  final index;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController controllerJenis;
  TextEditingController controllerPengeluaran;
  TextEditingController controllerNote;

  DateTime _dueDate;
  String _dateText = '';
  String newTask;
  String jumlah;
  String note;

  void _editTask() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "jenis": newTask,
        "duedate": _dateText,
        "jumlah": jumlah,
        "note": note
      });
    });
    Navigator.pop(context);
  }

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

  @override
  void initState() {
    super.initState();
    _dueDate = widget.duedate;
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    newTask = widget.jenis;
    note = widget.note;
    jumlah = widget.jumlah;

    controllerJenis = new TextEditingController(text: widget.jenis);
    controllerPengeluaran = new TextEditingController(text: widget.jumlah);
    controllerNote = new TextEditingController(text: widget.note);
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
                    "EDIT DATA",
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
              controller: controllerJenis,
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
              controller: controllerPengeluaran,
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
              controller: controllerNote,
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
                      _editTask();
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
