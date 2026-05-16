import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class OfflineAiService {
  static dynamic _activeModel;
  static dynamic _chatSession;
  static bool isReady = false;

  // SYSTEM INITIALIZER: Preps the native environment and installs the model weights
  static Future<void> initializeEngine(Function(double) onProgress) async {
    try {
      // 1. Initialize the global underlying FFI bridges cleanly
      await FlutterGemma.initialize();

      // 2. FIXED: Swapped .fromNetwork with .fromAsset to use your pre-bundled brain file
      await FlutterGemma.installModel(
        modelType: ModelType.gemmaIt,
      ).fromAsset(
        'assets/gemma_brain.task', // Points cleanly to your local asset registration link
      ).withProgress((progress) {
        onProgress(progress.toDouble()); // Casts standard integer progress metrics to doubles safely
      }).install(); 

      // 3. Pin runtime execution directly to device hardware GPU acceleration
      _activeModel = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.gpu,
      );

      // 4. Instantiates a unique ongoing chat tracking context history sequence
      _chatSession = await _activeModel.createChat();
      isReady = true;
      debugPrint("OFFLINE AI ENGINE CHRONICLES COMPILED SUCCESSFUL.");
    } catch (e) {
      debugPrint("CRITICAL INTERRUPT: LOCAL INFERENCE ENGAGEMENT EXCEPTION: $e");
    }
  }

  // DATA TRANSMISSION PIPELINE: FIXED to match flutter_gemma's stream API rules
  static Future<String> sendChatMessage(String playerPrompt) async {
    if (!isReady) {
      return "THE CHRONICLES SYSTEM CORE IS STILL CHARGING ITS COGNITIVE REFLEXES. TRY AGAIN IN A MOMENT.";
    }
    try {
      // 1. Append player query data block directly into the session tracker history
      await _chatSession.addQueryChunk(Message.text(
        text: playerPrompt,
        isUser: true,
      ));

      // 2. Safely collect and join token chunks from the asynchronous FFI engine stream
      String fullResponse = "";
      await for (final response in _chatSession.generateChatResponseAsync()) {
        if (response is String) {
          fullResponse += response;
        } else {
          try {
            fullResponse += (response as dynamic).token;
          } catch (_) {
            fullResponse += response.toString();
          }
        }
      }

      return fullResponse.trim();
    } catch (e) {
      return "LOCAL CONDUIT CHAT INTERRUPT RUNTIME: $e";
    }
  }
}