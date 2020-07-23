import 'package:app_keuangan/ui/addTask.dart';
import 'package:app_keuangan/ui/editTask.dart';
import 'package:app_keuangan/utils/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    setState(() {
      if (user != null) {
        print('Hello' + user.displayName.toString());
        print('Hello' + user.email.toString());
      }
    });
  }

  AlertDialog alertDialog = new AlertDialog(
    content: Container(
      height: 215.0,
      child: Column(
        children: <Widget>[
          ClipOval(
            child: new Image.asset("img/person.png"),
          ),
          Text(
            "Sign Out?? ",
            style: new TextStyle(fontSize: 16.0),
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => AddTask(
                      email: user.email,
                    )));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        elevation: 20.0,
        color: Colors.deepOrangeAccent,
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("task")
                  .where("email", isEqualTo: user.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                return new TaskList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),
          Container(
              height: 170.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage("img/nav.png"), fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(color: Colors.black, blurRadius: 8.0)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: new AssetImage("img/person.png"),
                                  fit: BoxFit.cover)),
                        ),
                        new Expanded(
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  user.displayName.toString(),
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.black45),
                                )
                              ],
                            ),
                          ),
                        ),
                        new IconButton(
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () {
                              AuthProvider().logOut();
                            })
                      ],
                    ),
                  ),
                  new Text(
                    "Aplikasi Keuangan",
                    style: new TextStyle(
                        color: Colors.black45,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        fontFamily: "atomicage"),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        String jenis = document[i].data['jenis'].toString();
        String jumlah = document[i].data['jumlah'].toString();
        String duedate = document[i].data['duedate'].toString();
        String note = document[i].data['note'].toString();

        return new Dismissible(
          key: new Key(document[i].documentID),
          onDismissed: (direction) {
            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Data Deleted"),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.dashboard,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                jenis,
                                style: TextStyle(
                                    fontSize: 20.0, letterSpacing: 1.0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.attach_money,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            Text(
                              jumlah,
                              style:
                                  TextStyle(fontSize: 18.0, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.date_range,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            Text(
                              duedate,
                              style:
                                  TextStyle(fontSize: 18.0, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.note,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                note,
                                style: TextStyle(
                                    fontSize: 18.0, letterSpacing: 1.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                new IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.deepOrangeAccent,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new EditTask(
                              jenis: jenis,
                              jumlah: jumlah,
                              duedate: DateTime.now(),
                              note: note,
                              index: document[i].reference,
                            )));
                  },
                ),
              ],
            ),
          ),
        );
      },
      itemCount: document.length,
    );
  }
}
