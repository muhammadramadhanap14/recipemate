import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/utils/ai_prompts.dart';
import 'package:recipemate/utils/constant_url.dart';

class OpenAiChatResponse {
  final String reply;
  final bool ready;
  final List<String>? options;

  OpenAiChatResponse({
    required this.reply,
    required this.ready,
    this.options,
  });

  factory OpenAiChatResponse.fromJson(Map<String, dynamic> json) {
    List<String>? opts;
    if (json['options'] != null && json['options'] is List) {
      opts = List<String>.from((json['options'] as List).map((e) => e.toString()));
    }
    return OpenAiChatResponse(
      reply: (json['reply'] ?? json['message'] ?? '') as String,
      ready: json['ready'] == true,
      options: opts,
    );
  }
}

class OpenAiRecipeResponse {
  final String name;
  final String cookTime;
  final List<String> ingredients;
  final List<String> steps;

  OpenAiRecipeResponse({
    required this.name,
    required this.cookTime,
    required this.ingredients,
    required this.steps,
  });

  factory OpenAiRecipeResponse.fromJson(Map<String, dynamic> json) {
    return OpenAiRecipeResponse(
      name: (json['name'] ?? 'Resep') as String,
      cookTime: (json['cook_time'] ?? json['cookTime'] ?? '') as String,
      ingredients: json['ingredients'] != null
          ? List<String>.from((json['ingredients'] as List).map((e) => e.toString()))
          : [],
      steps: json['steps'] != null
          ? List<String>.from((json['steps'] as List).map((e) => e.toString()))
          : [],
    );
  }
}

class OpenAiService {
  String get _apiKey {
    const envKey = String.fromEnvironment('OPENAI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    return ConstantUrl.openAiApiKey;
  }

  String get _endpointUrl {
    const envUrl = String.fromEnvironment('OPENAI_URL');
    if (envUrl.isNotEmpty) return envUrl;
    return ConstantUrl.openAiUrl;
  }

  Future<OpenAiChatResponse> sendChatMessage(List<ChatMessage> history) async {
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API Key tidak ditemukan.');
    }

    final messages = <Map<String, dynamic>>[
      {
        'role': 'system',
        'content': cookingSystemPrompt,
      },
      ...history.map(
        (m) => {
          'role': m.isUser ? 'user' : 'assistant',
          'content': m.text,
        },
      ),
    ];

    final payload = {
      'model': 'gpt-4o-mini',
      'messages': messages,
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'chat_response',
          'strict': true,
          'schema': {
            'type': 'object',
            'properties': {
              'reply': {'type': 'string'},
              'ready': {'type': 'boolean'},
              'options': {
                'type': ['array', 'null'],
                'items': {'type': 'string'}
              }
            },
            'required': ['reply', 'ready', 'options'],
            'additionalProperties': false,
          }
        }
      }
    };

    debugPrint('OpenAiService sendChatMessage POST to $_endpointUrl');
    final response = await http.post(
      Uri.parse(_endpointUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(payload),
    );

    debugPrint('OpenAiService sendChatMessage Status: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('OpenAI Error [${response.statusCode}]: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final contentStr = data['choices']?[0]?['message']?['content'];
    if (contentStr == null || contentStr.toString().isEmpty) {
      throw Exception('Respon dari OpenAI kosong.');
    }

    final contentJson = jsonDecode(contentStr.toString()) as Map<String, dynamic>;
    return OpenAiChatResponse.fromJson(contentJson);
  }

  Future<OpenAiRecipeResponse> generateRecipe(List<ChatMessage> context) async {
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API Key tidak ditemukan.');
    }

    final contextText = context.map((e) => '${e.isUser ? "User" : "Assistant"}: ${e.text}').join('\n');

    final payload = {
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content': recipeSystemPrompt,
        },
        {
          'role': 'user',
          'content': 'Berdasarkan percakapan berikut, buatkan resep lengkap:\n\n$contextText',
        }
      ],
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'recipe_response',
          'strict': true,
          'schema': {
            'type': 'object',
            'properties': {
              'name': {'type': 'string'},
              'cook_time': {'type': 'string'},
              'ingredients': {
                'type': 'array',
                'items': {'type': 'string'}
              },
              'steps': {
                'type': 'array',
                'items': {'type': 'string'}
              }
            },
            'required': ['name', 'cook_time', 'ingredients', 'steps'],
            'additionalProperties': false,
          }
        }
      }
    };

    debugPrint('OpenAiService generateRecipe POST to $_endpointUrl');
    final response = await http.post(
      Uri.parse(_endpointUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(payload),
    );

    debugPrint('OpenAiService generateRecipe Status: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('OpenAI Error [${response.statusCode}]: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final contentStr = data['choices']?[0]?['message']?['content'];
    if (contentStr == null || contentStr.toString().isEmpty) {
      throw Exception('Respon resep dari OpenAI kosong.');
    }

    final contentJson = jsonDecode(contentStr.toString()) as Map<String, dynamic>;
    return OpenAiRecipeResponse.fromJson(contentJson);
  }
}
