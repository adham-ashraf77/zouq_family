class NotificationsContent {
  int id;
  int seen;
  String image;
  String messageAr;
  String messageEn;
  String createdAt;

  NotificationsContent(
      {this.id,
      this.seen,
      this.image,
      this.messageAr,
      this.messageEn,
      this.createdAt});

  NotificationsContent.fromApi(Map<String, dynamic> json) {
    id = json['id'];
    seen = json['seen'];
    image = json['image'];
    messageAr = json['message_ar'];
    messageEn = json['message_en'];
    createdAt = json['created_at'];
  }
}
