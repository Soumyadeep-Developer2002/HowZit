import 'package:flutter/material.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/extra_features/some_features.dart';
import 'package:how_zit/fire_models_database/chat_messages_model.dart';
import 'package:how_zit/main.dart';

class ChatDesign extends StatefulWidget {
  final Messages msg;
  const ChatDesign({super.key, required this.msg});

  @override
  State<ChatDesign> createState() => _ChatDesignState();
}

class _ChatDesignState extends State<ChatDesign> {
  @override
  Widget build(BuildContext context) {
    return hereAllAPI.auth.currentUser!.uid == widget.msg.SenderID
        ? _senderBubble()
        : _receiverBubble();
  }

  Widget _senderBubble() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: mquery.width * 0.8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.msg.Message,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Features.readableTime(ctx: context, time: widget.msg.Sent),
                  style: TextStyle(fontSize: 11, color: Colors.black45),
                ),
                SizedBox(width: 6),
                widget.msg.Read.isNotEmpty
                    ? Icon(Icons.done_all_rounded, size: 18, color: Colors.blue)
                    : Icon(Icons.done_all_rounded, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiverBubble() {
    if (widget.msg.Read.isEmpty) {
      hereAllAPI.readStatus(widget.msg);
    }
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: mquery.width * 0.8),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.msg.Message,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Features.readableTime(ctx: context, time: widget.msg.Sent),
                  style: TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
