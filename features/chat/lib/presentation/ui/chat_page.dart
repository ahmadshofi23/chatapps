import 'package:chat/domain/entities/message_entity.dart';
import 'package:chat/presentation/bloc/chat_bloc.dart';
import 'package:chat/presentation/bloc/chat_event.dart';
import 'package:chat/presentation/bloc/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatPage extends StatefulWidget {
  final User currentUser;
  final String receiverId;
  final String receiverName;

  const ChatPage({
    Key? key,
    required this.currentUser,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print('object: ${widget.receiverId}');
    super.initState();
    BlocProvider.of<ChatBloc>(
      context,
      listen: false,
    ).add(LoadMessages(widget.currentUser.uid, widget.receiverId));
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context, listen: false).add(
        SendMessageEvent(
          MessageEntity(
            id: widget.currentUser.uid,
            senderId: widget.currentUser.uid,
            receiverId: widget.receiverId,
            text: text,
            timestamp: DateTime.now(),
            isRead: false,
          ),
        ),
      );
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Modular.to.pushNamed('/profile/${widget.receiverId}');
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.currentUser.photoURL ?? '',
                  ),
                ),
                const SizedBox(width: 8),
                Text(Uri.decodeComponent(widget.receiverName)),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatLoaded) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(child: Text('Start the conversation'));
                    }

                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final isMe = msg.senderId == widget.currentUser.uid;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6.0,
                          ),
                          child: Align(
                            alignment:
                                isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment:
                                  isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                // Nama Pengirim
                                if (!isMe)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      Uri.decodeComponent(widget.receiverName),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                // Bubble
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe
                                            ? Colors.blue[600]
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(
                                        isMe ? 16 : 0,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 0 : 16,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    msg.text,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat.Hm().format(msg.timestamp),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (isMe) ...[
                                      const SizedBox(width: 4),
                                      Icon(
                                        msg.isRead
                                            ? Icons.done_all
                                            : Icons.check,
                                        size: 14,
                                        color:
                                            msg.isRead
                                                ? Colors.lightBlue
                                                : Colors.grey,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No messages yet'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
