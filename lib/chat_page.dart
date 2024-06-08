import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:jack_social_app_v2/api_key.dart';

// import 'firebase/db.dart';
import 'model.dart';

class ChatPage extends StatefulWidget {
  final String character;

  const ChatPage({
    super.key,
    required this.character,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late final OpenAI _openAI;
  late bool _isLoading;

  final TextEditingController _textController = TextEditingController();
  late List<ChatMessage> _messages;
  String info = '';

  @override
  void initState() {
    _messages = [];
    _isLoading = false;

    // Initialize ChatGPT SDK
    _openAI = OpenAI.instance.build(
      token: ApiKey.openAIApiKey,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    // getInfo().then((value) => // This tells ChatGPT what his role is
    // _handleInitialMessage(
    //   'you are  sport psychology consulting. '
    //       'Whatever I tell you, provide and skeptical response  $info. '
    //       'Please send a super short '
    //       'intro message. Your name is Mind Sport Assistant.',
    // ));

    _handleInitialMessage(
      'you are  sport psychology consulting. '
          'Whatever I tell you, provide and skeptical response  $info. '
          'Please send a super short '
          'intro message. Your name is Mind Sport Assistant.',
    );

    super.initState();
  }


  Future<String> getInfo() async {
    // getUserInfo().then((info) {
    //   print(info);
    //   if (info != null) {
    //     return "based on my personal information: ${info!['gender']}, "
    //         "${info!['age']} years old, sport:${info!['sport']} ";
    //   } else {
    //     return '';
    //   }
    // });
    return '';
  }

  Future<void> _handleInitialMessage(String character) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    print(widget.character.toLowerCase());
    final request = ChatCompleteText(
      messages: [
        Messages(
            role: Role.assistant,
            content: "You are a ${widget.character.toLowerCase()}. ",
            //name: "analysis app",
        )
      ],
      maxToken: 200,
      model: GptTurbo0631Model(),
    );

    final response = await _openAI.onChatCompletion(request: request);

    ChatMessage message = ChatMessage(
      text: response!.choices.first.message!.content.trim().replaceAll('"', ''),
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _messages.insert(0, message);
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSubmit(String text) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    _textController.clear();

    // Add the user sent message to the thread
    ChatMessage prompt = ChatMessage(
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _messages.insert(0, prompt);
      });
    }

    // Handle ChatGPT request and response
    final request = ChatCompleteText(
      messages: [

        Messages(
          role: Role.assistant,
          content: "You are a ${widget.character.toLowerCase()}. ",
          //name: "analysis app",
        ),
        //Map.of({"role": "user", "content": text})
        Messages(
          role: Role.user,
          content: text,
          //name: "analysis app",
        )
      ],
      maxToken: 200,
      model: GptTurbo0631Model(),
    );
    final response = await _openAI.onChatCompletion(request: request);

    // Add the user received message to the thread
    ChatMessage message = ChatMessage(
      text: response!.choices.first.message!.content.trim(),
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _messages.insert(0, message);
        _isLoading = false;
      });
    }
  }

  Widget _buildChatList() {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (_, int index) {
          ChatMessage message = _messages[index];
          return _buildChatBubble(message);
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isSentByMe = message.isSentByMe;
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
        isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              margin: isSentByMe
                  ? const EdgeInsets.only(left: 100)
                  : const EdgeInsets.only(right: 100),
              decoration: BoxDecoration(
                color: isSentByMe
                    ? Color.fromRGBO(100, 204, 197, 1.0)
                    : Color.fromRGBO(23, 107, 135, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                  bottomLeft: isSentByMe
                      ? const Radius.circular(12.0)
                      : const Radius.circular(0.0),
                  bottomRight: isSentByMe
                      ? const Radius.circular(0.0)
                      : const Radius.circular(12.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSentByMe
                        ? 'You'
                        : '@${widget.character.toString().replaceAll(' ', '')}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSentByMe
                          ? Colors.black54
                          : Color.fromRGBO(85, 209, 229, 1.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${dateFormat.format(message.timestamp)} at ${timeFormat.format(message.timestamp)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _textController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message',
                enabled: !_isLoading,
              ),
              // Add this to handle submission when user presses done
              onSubmitted: _isLoading ? null : _handleSubmit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            // Add this to handle submission when user presses the send icon
            onPressed: _isLoading
                ? null
                : () => _handleSubmit(
              _textController.text,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your AI friend',
          style: TextStyle(
            //color: Colors.white,
          ),
        ),
        //backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   color: Color.fromRGBO(218, 255, 251, 1.0),
        //   image: DecorationImage(
        //       image: AssetImage("assets/background.png"),
        //       fit: BoxFit.cover,
        //       colorFilter: new ColorFilter.mode(
        //           Colors.black.withOpacity(0.3), BlendMode.dstATop)),
        // ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildChatList(),
                  const Divider(height: 1.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _buildChatComposer(),
                  ),
                ],
              ),
              if (_isLoading)
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: const CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
