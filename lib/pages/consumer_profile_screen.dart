import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/extra_features/some_features.dart';
import 'package:how_zit/fire_models_database/chat_consumers_model.dart';
import 'package:how_zit/main.dart';
import 'package:how_zit/pages/login_screen.dart';
import 'package:image_picker/image_picker.dart';

class ConsumerProfileScreen extends StatefulWidget {
  final Consumers user;

  const ConsumerProfileScreen({super.key, required this.user});

  @override
  State<ConsumerProfileScreen> createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
  final GlobalKey<FormState> _forFormKey = GlobalKey<FormState>();
  String? _imagePicker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade300,
          title: Row(
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.person_2_outlined, color: Colors.white),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),

                onPressed: () async {
                  Features.progressionBar(context);
                  await hereAllAPI.auth.signOut().then((User) async {
                    await GoogleSignIn().signOut().then((User) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    });
                  });
                },
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _forFormKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      _imagePicker != null
                          ? ClipOval(
                            child: Image.file(
                              File(_imagePicker!),
                              width: mquery.height * 0.2,
                              height: mquery.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          )
                          : ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.user.Image,
                              width: mquery.height * 0.2,
                              height: mquery.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                      Positioned(
                        right: -20,
                        bottom: -1,
                        child: MaterialButton(
                          onPressed: () {
                            _showImageAddSheet();
                          },
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      widget.user.Email,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      initialValue: widget.user.Name,
                      onSaved: (newValue) => hereAllAPI.me.Name = newValue!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      left: 15,
                      right: 15,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text("About"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      initialValue: widget.user.About,
                      onSaved: (newValue) => hereAllAPI.me.About = newValue!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        if (_forFormKey.currentState!.validate()) {
                          _forFormKey.currentState!.save();
                          hereAllAPI.updateUserDetails().then((Value) {
                            Features.showSnackBar(
                              context,
                              'Successfully updated the record',
                            );
                          });
                        }
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageAddSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(85)),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: mquery.height * .05,
            bottom: mquery.height * .05,
          ),
          children: [
            Text(
              "Profile Photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            mquery.width * .2,
                            mquery.height * .1,
                          ),
                          backgroundColor: Colors.green.shade100,
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            setState(() {
                              _imagePicker = image.path;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/camera.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            mquery.width * .2,
                            mquery.height * .1,
                          ),
                          backgroundColor: Colors.green.shade100,
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setState(() {
                              _imagePicker = image.path;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset(
                          'assets/images/gallery.png',
                          // height: mquery.height * 0.1,
                          // width: mquery.width * 0.1,
                          // fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
