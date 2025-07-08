import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:how_zit/design_here.dart/for_design_chat.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/fire_models_database/chat_consumers_model.dart';
import 'package:how_zit/pages/consumer_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<ChatScreen> {
  List<Consumers> _list = [];
  final List<Consumers> _searchingList = [];
  bool _isSearched = false;

  @override
  void initState() {
    super.initState();
    hereAllAPI.ownDetails();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade300,
          title: Row(
            children: [
              Expanded(
                child:
                    _isSearched
                        ? TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search by Name or Email...",
                          ),
                          onChanged: (Value) {
                            _searchingList.clear();
                            for (var i in _list) {
                              if (i.Name.toLowerCase().contains(
                                    Value.toLowerCase(),
                                  ) ||
                                  i.Email.toLowerCase().contains(
                                    Value.toLowerCase(),
                                  )) {
                                _searchingList.add(i);
                              }
                              setState(() {
                                _searchingList;
                              });
                            }
                          },
                        )
                        : RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "How",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "Zit",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ],
          ),
          actions: [
            //Search for any contact number...
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearched = !_isSearched;
                });
              },
              icon: Icon(_isSearched ? Icons.cancel_outlined : Icons.search),
              color: Colors.black87,
            ),

            //Go to my profile section
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConsumerProfileScreen(user: hereAllAPI.me),
                  ),
                );
              },
              icon: Icon(Icons.person_2_outlined),
              color: Colors.black87,
            ),
          ],
        ),
        body: StreamBuilder(
          stream: hereAllAPI.getOthersUSer(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                _list =
                    data?.map((e) => Consumers.fromJson(e.data())).toList() ??
                    [];
                if (_list.isNotEmpty) {
                  return ListView.builder(
                    itemCount:
                        _isSearched ? _searchingList.length : _list.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatCard(
                        user:
                            _isSearched ? _searchingList[index] : _list[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText("Oops! No friends found 😓"),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
