import 'package:baatain/Screens/profileScreen.dart';
import 'package:baatain/Screens/searchpage.dart';
import 'package:baatain/model/usermodel.dart';
import 'package:baatain/services/apis.dart';
import 'package:baatain/widgets/cardwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> _list = [];
  //for storing search
  final List<UserModel> _searchList = [];
  bool _isSeraching = false;

  @override
  void initState() {
    super.initState();
    APIs.selfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSeraching) {
            setState(() {
              _isSeraching = !_isSeraching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: _isSeraching
                ? null
                : SizedBox(
                    // height: 20,
                    width: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                  ),
            title: _isSeraching
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      autofocus: true,
                      //when search text changes then update the search list
                      onChanged: (value) {
                        //search logic
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              i.email!
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'search your contacts',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 1, 144, 113),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none),
                    ),
                  )
                : Text(
                    'Baatain',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSeraching = !_isSeraching;
                    });
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SearchScreen()));
                  },
                  icon: Icon(_isSeraching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              // SizedBox(
              //   width: 10,
              // ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  user: APIs.me,
                                )));
                  },
                  icon: Icon(Icons.more_vert)),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 5, 214, 169),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },
              child: Icon(
                Icons.chat_bubble_rounded,
                color: Colors.black,
              ),
            ),
          ),
          body: Column(
            children: [
              Divider(),
              Expanded(
                child: StreamBuilder(
                    stream: APIs.getAllUser(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => UserModel.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: _isSeraching
                                  ? _searchList.length
                                  : _list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CardWidget(
                                      chatuser: _isSeraching
                                          ? _searchList[index]
                                          : _list[index]),
                                );
                              },
                            );
                          } else {
                            return Center(child: Text("Users not found!"));
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
