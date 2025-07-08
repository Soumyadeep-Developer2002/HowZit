import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/fire_models_database/chat_consumers_model.dart';
import 'package:how_zit/fire_models_database/chat_messages_model.dart';
import 'package:how_zit/pages/chatting_screen.dart';

class ChatCard extends StatefulWidget {
  final Consumers user;
  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Messages? _msg;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChattingScreen(user: widget.user),
            ),
          );
        },
        child: StreamBuilder(
          stream: hereAllAPI.viewLastMessage(widget.user),
          builder: (context, snapshot) {
            return ListTile(
              leading: ClipOval(
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  imageUrl: widget.user.Image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) => Icon(Icons.person_2_outlined),
                ),
              ),
              title: Text(
                widget.user.Name,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              subtitle: Text(_msg != null ? _msg!.Message : widget.user.About),
              trailing: Text(
                "10.30 am",
                style: TextStyle(color: Colors.black26),
              ),
            );
          },
        ),
      ),
    );
  }
}
