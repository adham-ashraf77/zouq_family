class Message {
  Message({this.id, this.message, this.created, this.sender, this.attachments});

  int id;
  String message;
  DateTime created;
  Sender sender;
  List<Attachment> attachments = new List();

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        message: json["message"],
        created: DateTime.parse(json["created"]),
        sender: Sender.fromJson(json["sender"]),
        attachments: List<Attachment>.from(
            json["attachments"].map((x) => Attachment.fromJson(x))),
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

class Attachment {
  int id;
  String type;
  String path;
  
  Attachment({this.id, this.type, this.path});

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      Attachment(path: json["path"], type: json["type"]);
}
