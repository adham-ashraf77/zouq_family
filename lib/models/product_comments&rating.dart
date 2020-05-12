class ProductsCommentsAndRating {
  int commentId;
  int rate;
  String comment;
  UserInfo userInfo;

  ProductsCommentsAndRating({this.commentId, this.rate, this.comment, this.userInfo});

  factory ProductsCommentsAndRating.fromJson(Map<String, dynamic> fromJson) {
//    var list = fromJson['client'] as List;
//    List<UserInfo> userInfo =
//    list.map((value) => UserInfo.fromJson(value)).toList();

    return ProductsCommentsAndRating(
      commentId: fromJson['id'],
      comment: fromJson['comment'],
      rate: fromJson['rate'],
      userInfo: UserInfo.fromJson(fromJson['client']),
    );
  }
}

class UserInfo {
  int id;
  String name;
  String photo;

  UserInfo({this.id, this.name, this.photo});

  factory UserInfo.fromJson(Map<String, dynamic> fromJson) {
    return UserInfo(
      id: fromJson['id'],
      name: fromJson['name'],
      photo: fromJson['avatar'],
    );
  }
}
