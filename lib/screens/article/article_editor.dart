import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rimes_flutter/blocs/article/article_bloc.dart';
import 'package:rimes_flutter/blocs/article/article_event.dart';
import 'package:rimes_flutter/blocs/article/article_state.dart';
import '../../services/ws_service.dart';

class ArticleEditorScreen extends StatefulWidget {
  const ArticleEditorScreen({super.key});

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  late SocketService ws;
  final _debouncer = Debouncer(milliseconds: 300);
  int wordCount = 0;

  @override
  void initState() {
    super.initState();
    ws = SocketService();
    ws.connect();

    ws.onWordCount((count) {
      Fluttertoast.showToast(
        msg: "Word count: $count",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    });

    _bodyController.addListener(() {
      _debouncer.run(() {
        ws.sendText(_bodyController.text);
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _debouncer.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveArticle() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      Fluttertoast.showToast(msg: "Title and Body cannot be empty");
      return;
    }

    context.read<ArticleBloc>().add(CreateArticle(title: title, body: body));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (state is ArticleLoading) {
          Fluttertoast.showToast(msg: "Saving article...");
        } else if (state is ArticleLoaded) {
          Fluttertoast.showToast(msg: "Article saved successfully!");
          Navigator.pop(context,
              {'title': _titleController.text, 'body': _bodyController.text});
        } else if (state is ArticleError) {
          Fluttertoast.showToast(msg: "Error: ${state.error}");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Compose Article'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: 'Body',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: _saveArticle,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 300});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
