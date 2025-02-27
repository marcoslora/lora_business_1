import 'package:flutter/material.dart';

class ChatGPTPage extends StatefulWidget {
  const ChatGPTPage({Key? key}) : super(key: key);

  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatGPT")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Escribe tu mensaje aquí",
                border: OutlineInputBorder(),
              ),
            ),
            const ElevatedButton(
              onPressed: null,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
