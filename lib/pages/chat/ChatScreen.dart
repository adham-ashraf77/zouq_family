import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../I10n/app_localizations.dart';
import '../../models/chat/chat.dart';
import '../../services/chat.dart';
import '../../theme/common.dart';
import '../../widgets/chat/chatBubble.dart';

class ChatScreen extends StatefulWidget {
  String name;
  int id;
  ChatScreen({this.name = "", this.id});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController =
      new TextEditingController();
  FocusNode _msgNode = new FocusNode();

  int roomid;
  List<Message> messages = new List();

  String channel_type = 'private';
  String channel_name = 'private-channel';
  String event = '.message.sent';

  Echo echo;
  FlutterPusher pusherClient;
  PusherOptions options;

  bool isLoading = true;
  bool chatloading = false;
  bool uploadImgLoading = false;
  bool is_connected = false;

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    createRoom();
  }

  createRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    roomid = await ChatService().startRoom(id: widget.id);
    channel_name = 'rooms.$roomid';
    options = PusherOptions(
        host: 'api.dhuqapp.com',
        port: 6001,
        encrypted: false,
        auth: PusherAuth('http://api.dhuqapp.com/api/broadcasting/auth',
            headers: {'Authorization': 'Bearer $token'}));
    pusherClient = FlutterPusher(
      "468a43433dad5808c2",
      options,
      enableLogging: true,
    );

    echo = new Echo({
      'broadcaster': 'pusher',
      'client': pusherClient,
      "wsHost": 'api.dhuqapp.com',
      "httpHost": 'api.dhuqapp.com',
      "wsPort": 6001,
      'auth': {
        "headers": {'Authorization': 'Bearer $token'}
      },
      'authEndpoint': 'http://api.dhuqapp.com/api/broadcasting/auth',
      "disableStats": true,
      "forceTLS": false,
      "enabledTransports": ['ws', 'wss']
    });
    echo.private(channel_name).listen('.message.sent', (e) {
      print(e);
      messages.insert(0, Message.fromJson(e));
      if (mounted) {
        setState(() {});
      }
    });
    await getMessages();
  }

  getMessages() async {
    messages = await ChatService().fetchMessages(roomId: roomid);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  getMoreMessage({int lastMsgId}) async {
    List<Message> msg = await ChatService()
        .fetchMessages(roomId: roomid, lastmessage: lastMsgId);
    msg.forEach((i) {
      messages.add(i);
    });
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  sendMessage() async {
    if (textEditingController.text.isNotEmpty) {
      chatloading = true;
      if (mounted) {
        setState(() {});
      }
      await ChatService()
          .sendChatMessage(roomId: roomid, message: textEditingController.text);
      textEditingController.clear();
      chatloading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  sendImage() async {
    await getImage();
    if (_image != null) {
      uploadImgLoading = true;
      if (mounted) {
        setState(() {});
      }
      await ChatService().sendImg(roomId: roomid, img: _image);
      _image = null;
      uploadImgLoading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  void onConnectionStateChange(ConnectionStateChange event) {
    if (event.currentState == 'CONNECTED') {
      setState(() {
        is_connected = true;
      });
    } else if (event.currentState == 'DISCONNECTED') {
      setState(() {
        is_connected = false;
      });
    } else {
      print(event.currentState);
    }
  }

  Widget inputFiled() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              child: uploadImgLoading
                  ? CircularProgressIndicator(
                      backgroundColor: accent,
                    )
                  : new IconButton(
                      icon: new Icon(Icons.photo),
                      onPressed: () {
                        sendImage();
                      },
                      color: accent,
                    ),
            ),
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          // Text input
          Flexible(
            child: Container(
              child: TextField(
                autofocus: true,
                focusNode: _msgNode,
                textInputAction: TextInputAction.send,
                onEditingComplete: () {
                  sendMessage();
                },
                style: TextStyle(color: textColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('typemsg'),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          // Send Message Button
          Material(
            child: new Container(
              child: chatloading
                  ? CircularProgressIndicator(
                      backgroundColor: accent,
                    )
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                      },
                      color: accent,
                    ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  void unFocus() {
    _msgNode.unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.name}",
            style: TextStyle(color: accent),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: accent,
                ),
              )
            : ListView(
                children: [
                  LazyLoadScrollView(
                    scrollOffset: 400,
                    onEndOfPage: () {
                      getMoreMessage(
                          lastMsgId: messages[messages.length - 1].id);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, int index) {
                            return ChatBubble(
                              isImg: messages[index].attachments.length == 0
                                  ? false
                                  : true,
                              isMyMsg: messages[index].sender.id != widget.id
                                  ? true
                                  : false,
                              imgLink: messages[index].attachments.length == 0
                                  ? ""
                                  : messages[index].attachments[0].path,
                              msg: messages[index].message,
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: inputFiled(),
                  ),
                ],
              ),
      ),
    );
  }
}
