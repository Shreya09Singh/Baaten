// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baatain/Screens/chatScreen.dart';
import 'package:baatain/helper/datetimeutil.dart';
import 'package:baatain/model/messagemodel.dart';
import 'package:baatain/model/usermodel.dart';
import 'package:baatain/services/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final UserModel chatuser;

  const CardWidget({
    Key? key,
    required this.chatuser,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    MessageModel? _msg;

    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Chatscreen(user: widget.chatuser)));
          },
          child: StreamBuilder(
              stream: APIs.getlastMessages(widget.chatuser),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final _list = data
                        ?.map((e) => MessageModel.fromJson(e.data()))
                        .toList() ??
                    [];
                if (_list.isNotEmpty) _msg = _list[0];
                // if (data != null && data.first.exists) {
                //   _msg = MessageModel.fromJson(data.first.data());
                // }
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.chatuser.image.toString(),
                      maxWidth: 60,
                      maxHeight: 60,
                      errorListener: (p0) {
                        CircleAvatar(
                          child: Icon(Icons.person),
                        );
                      },
                    ),
                  ),
                  // leading: ClipRRect(
                  //   borderRadius: BorderRadius.circular(mq.height * 0.075),
                  //   child: CachedNetworkImage(
                  //     width: mq.width * .12,
                  //     height: mq.height * .12,
                  //     imageUrl: widget.chatuser.image.toString(),
                  //     // placeholder: (context, url) => CircularProgressIndicator(),
                  //     errorWidget: (context, url, error) =>
                  //         CircleAvatar(child: Icon(Icons.person)),
                  //   ),
                  // ),
                  title: Text(widget.chatuser.name.toString()),
                  subtitle: Text(
                      maxLines: 1,
                      _msg != null
                          ? _msg!.message
                          : widget.chatuser.name.toString()),
                  trailing: _msg == null
                      ? null
                      : _msg!.read.isEmpty && _msg!.fromId == APIs.user.uid
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.greenAccent.shade700,
                              ),
                              height: 15,
                              width: 15,
                            )
                          : Text(MyDateUtil.getlastMessageTime(
                              context: context, time: _msg!.send)),
                );
              })),
    );
  }
}
