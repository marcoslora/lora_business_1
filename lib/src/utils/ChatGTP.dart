import 'package:dart_openai/dart_openai.dart';

// import 'package:dart_openai/dart_openai.dart';

class OpenAIChatService {
  final String model;
  final double temperature;
  final int maxTokens;
  final String toolChoice;

  OpenAIChatService({
    this.model = "gpt-3.5-turbo-1106",
    this.temperature = 0.2,
    this.maxTokens = 500,
    this.toolChoice = "auto",
  });

  void setApiKey(String apiKey) {
    OpenAI.apiKey = apiKey;
  }

  Future<OpenAIChatCompletionModel> sendMessage(String message) async {
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(message),
      ],
      role: OpenAIChatMessageRole.user,
    );

    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "return any message you are given as JSON.",
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    final requestMessages = [systemMessage, userMessage];

    return await OpenAI.instance.chat.create(
      model: model,
      responseFormat: {"type": "json_object"},
      seed: DateTime.now().millisecondsSinceEpoch,
      messages: requestMessages,
      temperature: temperature,
      maxTokens: maxTokens,
      toolChoice: toolChoice,
    );
  }

  Stream<OpenAIStreamChatCompletionModel> createChatStream(String message) {
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(message),
      ],
      role: OpenAIChatMessageRole.user,
    );

    return OpenAI.instance.chat.createStream(
      model: model,
      messages: [userMessage],
      seed: DateTime.now().millisecondsSinceEpoch,
      n: 2,
    );
  }
}
