import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../I10n/app_localizations.dart';
import '../../models/chat/conversations.dart';
import '../../services/chat.dart';
import '../../theme/common.dart';
import '../../utils/helpers.dart';
import 'ChatScreen.dart';

class ConversationsListScreen extends StatefulWidget {
  @override
  _ConversationsListScreenState createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  List<Conversation> conversations = new List();
  bool isLoading = true;
  int userId;

  getConversations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    conversations = await ChatService().getConversations();
    userId = prefs.getInt("id");
    print(userId);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('conversations'),
            style: TextStyle(color: accent),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: conversations.length,
                itemBuilder: (BuildContext context, int index) {
                  int userIndex;
                  if (conversations[index].members[0].id == userId) {
                    userIndex = 1;
                  } else {
                    userIndex = 0;
                  }
                  return InkWell(
                    onTap: () {
                      pushPage(
                          context,
                          ChatScreen(
                            id: conversations[index].members[userIndex].id,
                            name: "${conversations[index].members[userIndex].name}",
                          ));
                    },
                    child: ListTile(
                      title: Text("${conversations[index].members[userIndex].name}"),
                      subtitle: Text("${conversations[index].lastMessage.message}"),
                      trailing: Container(
                        width: 60,
                        height: 60,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.contain,
                            placeholder: "assets/icons/loading.gif",
                            image:
                                "${conversations[index].members[userIndex].avatar}",
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ));
  }
}
