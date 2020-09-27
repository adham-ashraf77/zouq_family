class Conversation {
  Conversation({
    this.id,
    this.name,
    this.created,
    this.lastUpdate,
    this.lastMessage,
    this.members,
  });

  int id;
  dynamic name;
  DateTime created;
  DateTime lastUpdate;
  LastMessage lastMessage;
  List<Sender> members;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        name: json["name"],
        created: DateTime.parse(json["created"]),
        lastUpdate: DateTime.parse(json["last_update"]),
        lastMessage: LastMessage.fromJson(json["last_message"]),
        members:
            List<Sender>.from(json["members"].map((x) => Sender.fromJson(x))),
      );
}

class LastMessage {
  LastMessage({
    this.id,
    this.message,
    this.created,
    this.sender,
  });

  int id;
  String message;
  DateTime created;
  Sender sender;

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        message: json["message"],
        created: DateTime.parse(json["created"]),
        sender: Sender.fromJson(json["sender"]),
      );
}

class Sender {
  Sender({
    this.id,
    this.name,
    this.avatar,
  });

  int id;
  String name;
  String avatar;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        name: json["name"],
        avatar: json["image"],
      );
}
