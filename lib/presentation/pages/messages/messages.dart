import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:kyc_test/core/constants/themes/app_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool _isLoading = true;

  // Dummy list of chat users
  List<_ChatUser> get _chatUsers => const [
    _ChatUser(
      id: 'user_1',
      name: 'Alice Johnson',
      lastMessage: 'Hey! How are you?',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    _ChatUser(
      id: 'user_2',
      name: 'Bob Smith',
      lastMessage: 'Let’s meet tomorrow.',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    _ChatUser(
      id: 'user_3',
      name: 'Charlie Brown',
      lastMessage: 'I sent the files.',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    _ChatUser(
      id: 'user_4',
      name: 'Bytes4Future',
      lastMessage: 'Hello im trying to contact you ',
      avatarUrl: 'https://i.pravatar.cc/150?img=6',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Fake loading – replace this with your real async fetch later
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("List of Investors & Startups"),
      ),
      backgroundColor: Colors.transparent,
      body: Skeletonizer(
        effect: const ShimmerEffect(
            baseColor: Color(0xFF032A2A),
            highlightColor: Color(0xFF064E4E),
          ),
          containersColor: const Color(0xFF032A2A),
        enabled: _isLoading,
        child: ListView.separated(
          itemCount: _chatUsers.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = _chatUsers[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                user.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _isLoading
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatPage(otherUser: user),
                        ),
                      );
                    },
            );
          },
        ),
      ),
    );
  }
}

class _ChatUser {
  final String id;
  final String name;
  final String lastMessage;
  final String avatarUrl;

  const _ChatUser({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
  });
}

class ChatPage extends StatefulWidget {
  final _ChatUser otherUser;

  const ChatPage({super.key, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final types.User _currentUser;
  late final types.User _otherUser;

  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();

    // Your logged-in user (you)
    _currentUser = const types.User(
      id: 'my_user_id',
      firstName: 'You',
      imageUrl: 'https://i.pravatar.cc/150?img=10', // your avatar
    );

    // The person you’re chatting with
    _otherUser = types.User(
      id: widget.otherUser.id,
      firstName: widget.otherUser.name,
      imageUrl: widget.otherUser.avatarUrl, // image in DM
    );

    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    final now = DateTime.now().millisecondsSinceEpoch;

    _messages = [
      types.TextMessage(
        id: 'init_$now',
        author: _otherUser,
        createdAt: now,
        text: widget.otherUser.lastMessage,
      ),
    ];

    setState(() {});
  }

  void _handleSendPressed(types.PartialText partialText) {
    final now = DateTime.now().millisecondsSinceEpoch;

    final textMessage = types.TextMessage(
      id: now.toString(),
      author: _currentUser,
      createdAt: now,
      text: partialText.text,
    );

    setState(() {
      _messages.insert(0, textMessage); // newest at top
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDarker,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.otherUser.avatarUrl),
            ),
            const SizedBox(width: 8),
            Text(widget.otherUser.name),
          ],
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _currentUser,
        showUserAvatars: true,
        showUserNames: true,
        inputOptions: const InputOptions(
          sendButtonVisibilityMode: SendButtonVisibilityMode.always,
        ),
        theme: DefaultChatTheme(
          backgroundColor: AppTheme.cardDark,
          primaryColor: AppTheme.primaryDark,
          secondaryColor: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
