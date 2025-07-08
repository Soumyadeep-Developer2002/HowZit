import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:how_zit/fire_models_database/chat_consumers_model.dart';
import 'package:how_zit/main.dart';

class OtherUserProfile extends StatefulWidget {
  final Consumers user;

  const OtherUserProfile({super.key, required this.user});

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  String? _imagePicker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade300,
        title: Center(child: Text(widget.user.Name)),
      ),
      body: Center(
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                widget.user.Email,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                widget.user.Name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Text(
                widget.user.About,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.keyboard_return),
            ),
          ],
        ),
      ),
    );
  }
}
