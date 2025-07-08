import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:how_zit/design_here.dart/chat_design.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/fire_models_database/chat_consumers_model.dart';
import 'package:how_zit/fire_models_database/chat_messages_model.dart';
import 'package:how_zit/main.dart';
import 'package:how_zit/pages/other_user_profile.dart';

class ChattingScreen extends StatefulWidget {
  final Consumers user;
  const ChattingScreen({super.key, required this.user});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  List<Messages> _list = [];
  final TextEditingController _letsTalk = TextEditingController();
  bool _emoji = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.green.shade300),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.green.shade300,
              flexibleSpace: _designAppBar(),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Color.fromARGB(255, 245, 238, 229),

            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: hereAllAPI.getMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list =
                              data
                                  ?.map((e) => Messages.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              itemCount: _list.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatDesign(msg: _list[index]);
                              },
                            );
                          } else {
                            return Center(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    "Type something below to break the ice 🧊...",
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                                isRepeatingAnimation: true,
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                _messageBar(),
                _emoji
                    ? EmojiPicker(
                      textEditingController: _letsTalk,
                      config: Config(
                        height: mquery.height * .3,
                        emojiViewConfig: EmojiViewConfig(
                          backgroundColor: Colors.lime.shade100,
                          emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                        ),
                        bottomActionBarConfig: BottomActionBarConfig(
                          backgroundColor: Colors.grey.shade600,
                          buttonColor: Colors.red,
                          buttonIconColor: Colors.white70,
                        ),
                      ),
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _designAppBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtherUserProfile(user: widget.user),
          ),
        );
      },
      child: StreamBuilder(
        stream: hereAllAPI.otherUserActiveInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => Consumers.fromJson(e.data())).toList() ?? [];
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left),
              ),
              ClipOval(
                child: CachedNetworkImage(
                  height: 30,
                  width: 30,
                  imageUrl: list.isNotEmpty ? list[0].Image : widget.user.Image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) => Icon(Icons.person_2_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].Name : widget.user.Name,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : list[0].LastActive
                          : widget.user.LastActive,
                      style: TextStyle(color: Colors.black38),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _messageBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _emoji = !_emoji;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions_rounded,
                        color: Colors.pink,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        onTap: () {
                          if (_emoji) {
                            setState(() {
                              _emoji = false;
                            });
                          }
                        },
                        controller: _letsTalk,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.photo_album_outlined),
                    SizedBox(width: 8),
                    Icon(Icons.camera_alt_rounded, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (_letsTalk.text.isNotEmpty) {
                hereAllAPI.sendMessages(widget.user, _letsTalk.text);
                _letsTalk.clear();
              }
            },
            icon: Icon(Icons.send_sharp, color: Colors.green.shade900),
          ),
        ],
      ),
    );
  }
}
