// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:baatain/model/messagemodel.dart';
import 'package:baatain/services/apis.dart';
import 'package:baatain/widgets/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';

import 'package:baatain/model/usermodel.dart';
import 'package:image_picker/image_picker.dart';

class Chatscreen extends StatefulWidget {
  final UserModel user;
  const Chatscreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  bool _showingemojis = false;
  List<MessageModel> _list = [];
  final _inputcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_showingemojis) {
            setState(() {
              _showingemojis = !_showingemojis;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: _appbar(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 0, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.call),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.video_call))
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // SizedBox(
              //   height: 7,
              // ),

              Divider(),
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(child: SizedBox());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        _list = data
                                ?.map((e) => MessageModel.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: MessageCard(message: _list[index]));
                            },
                          );
                        } else {
                          return Center(
                              child: Text(
                            "Say hii 👋",
                            style: TextStyle(fontSize: 20),
                          ));
                        }
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _chatinput(),
              ),

              _showingemojis
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * .40,
                      child: EmojiPicker(
                        textEditingController:
                            _inputcontroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                        config: Config(
                          height: 256,

                          // bgColor: const Color(0xFFF2F2F2),
                          checkPlatformCompatibility: true,
                          emojiViewConfig: EmojiViewConfig(
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                          ),
                          swapCategoryAndBottomBar: true,
                          skinToneConfig: const SkinToneConfig(),
                          categoryViewConfig: const CategoryViewConfig(),
                          bottomActionBarConfig: const BottomActionBarConfig(),
                          searchViewConfig: const SearchViewConfig(),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    final mq = MediaQuery.of(context).size;
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        CircleAvatar(
          radius: 25,
          backgroundImage: CachedNetworkImageProvider(
            widget.user.image.toString(),
            maxWidth: 60,
            maxHeight: 60,
            errorListener: (p0) {
              CircleAvatar(
                child: Icon(Icons.person),
              );
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.name!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'last seen 12:30 pm',
              style: TextStyle(fontSize: 12),
            )
          ],
        )
      ],
    );
  }

  Widget _chatinput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showingemojis = !_showingemojis;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions_sharp,
                      color: Colors.black,
                    )),
                Expanded(
                    child: TextFormField(
                  controller: _inputcontroller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () {
                    if (_showingemojis == true)
                      setState(() {
                        _showingemojis = !_showingemojis;
                      });
                  },
                  decoration: InputDecoration(
                      hintText: "Type a message..", border: InputBorder.none),
                )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        APIs.sendChatImage(widget.user, File(image.path));
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: const Color.fromARGB(255, 0, 212, 166),
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log('Image path: ${image.path}');

                        APIs.sendChatImage(widget.user, File(image.path));
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
          onPressed: () {
            if (_inputcontroller.text.isNotEmpty) {
              APIs.sendMessages(widget.user, _inputcontroller.text, Type.text);
              _inputcontroller.text = '';
            }
          },
          minWidth: 0,
          color: const Color.fromARGB(255, 0, 212, 166),
          shape: CircleBorder(),
          child: Icon(
            Icons.send,
          ),
        )
      ],
    );
  }
}
