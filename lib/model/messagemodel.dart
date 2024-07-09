class MessageModel {
  MessageModel({
    required this.fromId,
    required this.read,
    required this.toId,
    required this.message,
    required this.type,
    required this.send,
  });
  late final String fromId;
  late final String read;
  late final String toId;
  late final String message;
  late final Type type;
  late final String send;

  MessageModel.fromJson(Map<String, dynamic> json) {
    fromId = json['from_Id'].toString();
    read = json['read'].toString();
    toId = json['to_Id'].toString();
    message = json['message'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    send = json['send'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['from_Id'] = fromId;
    _data['read'] = read;
    _data['to_Id'] = toId;
    _data['message'] = message;
    _data['type'] = type.name;
    _data['send'] = send;
    return _data;
  }
}

enum Type { text, image }
