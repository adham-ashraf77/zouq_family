import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../ConstantVarables.dart';
import '../models/chat/chat.dart';
import '../models/chat/conversations.dart';

class ChatService {
  final String apiUrl = "${ConstantVarable.baseUrl}/api/chat/rooms/";
  static String startChat = "start?receiver_id=";
  static String messages = "messages";
  static String rooms = "?status=all";

  Future<int> startRoom({int id}) async {
    int roomId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var header = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    Dio dio = new Dio();
    var res =
        await dio.post("$apiUrl$startChat$id&receiver_type=user", options: Options(headers: header));
    roomId = res.data["room_id"];
    return roomId;
  }

  Future<List<Conversation>> getConversations() async {
    List<Conversation> list = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var header = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    Dio dio = new Dio();
    print("$apiUrl$rooms");
    var res = await dio.get("$apiUrl$rooms", options: Options(headers: header));
    var data = res.data['rooms'];
        print("---");
        print(res.data);

    data.forEach((value) {
      list.add(Conversation.fromJson(value));
    });
    return list;
  }

  Future<List<Message>> fetchMessages({int roomId, int lastmessage}) async {
    List<Message> msgs = new List();
    String link = "/$messages";
    if (lastmessage != null) {
      link += "?last_message_id=$lastmessage";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var header = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    Dio dio = new Dio();
    
    var res =
        await dio.get("$apiUrl$roomId$link", options: Options(headers: header));
    var data = res.data['messages'];
    data.forEach((value) {
      msgs.add(Message.fromJson(value));
    });
    return msgs;
  }

  Future<Message> sendChatMessage({int roomId, String message}) async {
    Message msg;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var header = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    var data = {'message': message};
    Dio dio = new Dio();
    await dio.post("$apiUrl$roomId/$messages",
        data: data, options: Options(headers: header));
    return msg;
  }
}
