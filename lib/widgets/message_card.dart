// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baatain/helper/datetimeutil.dart';
import 'package:baatain/services/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:baatain/model/messagemodel.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  MessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId ? _whiteCard() : _greenCard();
  }

  // for user message
  Widget _greenCard() {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 8 : 11),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 29, 206, 168),
                border:
                    Border.all(color: const Color.fromARGB(255, 0, 212, 166)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.message.type == Type.text
                    ? Text(
                        widget.message.message,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          // width: 120,
                          // height: 120,
                          imageUrl: widget.message.message,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image,
                            size: 70,
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      MyDateUtil.getFormattedtime(
                          context: context, time: widget.message.send),
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 16,
                      color: Colors.blue,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        //message time
        // Padding(padding:EdgeInsets.only(right: 4) )
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.3,
        ),
      ],
    );
  }

  // for our message
  Widget _whiteCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(padding: EdgeInsets.only(right: 4)),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.3,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 8 : 11),
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.message.type == Type.text
                    ? Text(
                        widget.message.message,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          // width: 120,
                          // height: 120,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                          imageUrl: widget.message.message,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image,
                            size: 70,
                          ),
                        ),
                      ),
                Padding(padding: EdgeInsets.only(right: 4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      MyDateUtil.getFormattedtime(
                          context: context, time: widget.message.send),
                      style: TextStyle(fontSize: 11, color: Colors.black),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    if (widget.message.read.isNotEmpty)
                      Icon(
                        Icons.done_all,
                        size: 16,
                        color: Colors.blue,
                      )
                  ],
                )
              ],
            ),
          ),
          //message time
        )
      ],
    );
  }
}
