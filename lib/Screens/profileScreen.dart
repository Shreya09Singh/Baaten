// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:baatain/authentication/loginScreen.dart';
import 'package:baatain/helper/dialog.dart';
import 'package:baatain/model/usermodel.dart';
import 'package:baatain/services/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  ProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  String? _img;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Profile '),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 17,
          ),
          child: Container(
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            width: 110,
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 5, 214, 169),
              onPressed: () async {
                Dialogs.showProgressBar(context);
                await FirebaseAuth.instance.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hiding progressIndicatorBar
                    Navigator.pop(context);
                    //move from home page
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginPage()));
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(children: [
                      _img != null
                          ?
                          //local image
                          ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: Image.file(
                                File(_img!),
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            )
                          :

                          //sever image
                          ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                                imageUrl: widget.user.image.toString(),
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(child: Icon(Icons.person)),
                              ),
                            ),
                      Positioned(
                          bottom: 0,
                          left: 60,
                          child: MaterialButton(
                            shape: CircleBorder(),
                            color: Colors.white,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            child: Icon(Icons.edit,
                                color: Color.fromARGB(255, 6, 167, 132)),
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.user.email.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (value) => APIs.me.name = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'required field',
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        label: Text('Name'),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 1, 144, 113),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 1, 144, 113),
                                width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (value) => APIs.me.about = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'required feild',
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        label: Text('About'),
                        prefixIcon: Icon(
                          Icons.info,
                          color: Color.fromARGB(255, 1, 144, 113),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 1, 144, 113),
                                width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: mq.width / 2.3,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 4, 191, 150))),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            log('inside validator');
                            APIs.userUpdatevalue()
                                .then((value) => Dialogs.showMyDialog(context));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Update",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet for picking up profile pic for users
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        // shape: ,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            children: [
              Text(
                "Pick profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //teking picture from gallery***************************
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image path: ${image.path}');
                          setState(() {
                            _img = image.path;
                          });

                          APIs.uploadProfileImage(File(_img!));
                          Navigator.pop(context);
                        }
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/galaryimg.webp'),
                      )),

                  //teking picture from camera //////////////////////////
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image path: ${image.path}');
                          setState(() {
                            _img = image.path;
                          });
                          APIs.uploadProfileImage(File(_img!));
                          //for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/camera.jpg'),
                      ))
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          );
        });
  }
}
