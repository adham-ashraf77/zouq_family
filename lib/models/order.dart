import 'package:zouqadmin/models/comment.dart';
import 'package:zouqadmin/models/product.dart';

class Order {
  final String id;
  final String name;
  final String date;
  final String time;
  final String contents;
  final String imageUrl;
  final String price;
  final String phoneNumber;
  final double rate;
  final List<Comment> comments;
  final List<Product> product;
  final String status;

  Order(
      {this.id,
      this.status,
      this.comments,
      this.rate,
      this.phoneNumber,
      this.name,
      this.date,
      this.time,
      this.contents,
      this.imageUrl,
      this.price,
      this.product});
}
