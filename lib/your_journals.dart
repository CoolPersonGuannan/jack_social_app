import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show  kIsWeb;
import 'package:flutter/material.dart';
import 'package:jack_social_app_v2/form_widget.dart';
import 'package:jack_social_app_v2/main.dart';

class YourJournals extends StatefulWidget {
  const YourJournals({Key? key}) : super(key: key);

  @override
  _YourJournalsState createState() => _YourJournalsState();
}

class _YourJournalsState extends State<YourJournals> {
  late User user;
  late DatabaseReference _messagesRef;
  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  bool _anchorToBottom = true;
  bool initialized = false;

  @override
  void initState() {
    user = auth.currentUser!;
    init();
    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });
    super.initState();
  }

  Future<void> init() async {

    final database = FirebaseDatabase.instance;
    _messagesRef = database.ref('users/${user.uid}');

    database.setLoggingEnabled(false);

    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }

    setState(() {
      initialized = true;
    });

    final messagesQuery = _messagesRef.limitToLast(10);

    _messagesSubscription = messagesQuery.onChildAdded.listen(
          (DatabaseEvent event) {
        print('Child added: ${event.snapshot.value}');
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messagesSubscription.cancel();
  }


  Future<void> _deleteMessage(DataSnapshot snapshot) async {
    final messageRef = _messagesRef.child(snapshot.key!);
    final snapshotMap = snapshot.value as Map;
    final picRef = FirebaseStorage.instance.refFromURL(snapshotMap["picURL"]);
    await picRef.delete();
    await messageRef.remove();
  }

  void _setAnchorToBottom(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _anchorToBottom = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) return Container();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Journey"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Checkbox(
              onChanged: _setAnchorToBottom,
              value: _anchorToBottom,
            ),
            title: const Text('Anchor to bottom'),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              key: ValueKey<bool>(_anchorToBottom),
              query: _messagesRef,
              reverse: _anchorToBottom,
              itemBuilder: (context, snapshot, animation, index) {
                final diaryList = snapshot.value! as Map;
                return SizeTransition(
                  sizeFactor: animation,
                  child: Card(
                    child: ListTile(
                      leading: Image.network(diaryList["picURL"]),
                      trailing: IconButton(
                        onPressed: () => _deleteMessage(snapshot),
                        icon: const Icon(Icons.delete),
                      ),
                      title: Text(diaryList["title_for_today"]),
                      subtitle: Text(diaryList["mood_of_the_day"]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FormPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


