class Message {
  Message({
    this.id,
    this.message,
    this.created,
    this.sender,
  });

  int id;
  String message;
  DateTime created;
  Sender sender;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        message: json["message"],
        created: DateTime.parse(json["created"]),
        sender: Sender.fromJson(json["sender"]),
      );
}

class Sender {
  Sender({this.id, this.name, this.avatar, this.type});

  int id;
  String name;
  String avatar;
  String type;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      type: json["type"]);
}
