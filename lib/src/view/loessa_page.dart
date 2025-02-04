import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lora_business_1/src/utils/ChatGTP.dart';

import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart'; // Asegúrate de importar dart_openai

class ChatGPTPage extends StatefulWidget {
  const ChatGPTPage({Key? key}) : super(key: key);

  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  final TextEditingController _controller = TextEditingController();
  late final OpenAIChatService _chatService;

  // late final Stream<OpenAIStreamChatCompletionModel> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatService = OpenAIChatService();
    _chatService.setApiKey(
      dotenv.env['OPENAI_API_KEY']!,
    );
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Hello my friend!",
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

// The request to be sent.
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo-1106",
      messages: [
        userMessage,
      ],
      seed: 423,
      n: 2,
    );
    chatStream.listen(
      (streamChatCompletion) {
        final content = streamChatCompletion.choices.first.delta.content;
        print(content);
      },
      onDone: () {
        print("Done");
      },
    );
  }

  void _startChat() {
    setState(() {
      // _chatStream = _chatService.createChatStream(_controller.text);
    });
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
            ElevatedButton(
              onPressed: _startChat,
              child: const Text('Enviar'),
            ),
            // Expanded(
            //   child: StreamBuilder<OpenAIStreamChatCompletionModel>(
            //     stream: _chatStream,
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const CircularProgressIndicator();
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       } else if (snapshot.hasData) {
            //         return ListView.builder(
            //           itemCount: snapshot.data!.choices.length,
            //           itemBuilder: (context, index) {
            //             final choice = snapshot.data!.choices[index];

            //             // Concatenar todos los textos de los items de contenido
            //             final texts = choice.delta.content
            //                 ?.map((contentItem) => contentItem.text)
            //                 .join();

            //             return ListTile(
            //               title: Text(texts!),
            //             );
            //           },
            //         );
            //       } else {
            //         return const Text('No hay mensajes.');
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
