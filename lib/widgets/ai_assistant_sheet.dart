import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/offline_ai_service.dart';

// BROADCAST LINK: Notifies any open layout widgets the exact millisecond the offline AI finishes waking up
final ValueNotifier<bool> _aiReadyNotifier = ValueNotifier<bool>(OfflineAiService.isReady);

class AIAssistantWrapper extends StatefulWidget {
  final Widget child;
  const AIAssistantWrapper({super.key, required this.child});

  @override
  State<AIAssistantWrapper> createState() => _AIAssistantWrapperState();
}

class _AIAssistantWrapperState extends State<AIAssistantWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // FIXED: Added 'await' and tied completion directly to our broadcast listener notifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () async {
        if (!OfflineAiService.isReady) {
          try {
            // Await ensures steps 3 and 4 (GPU assignment and session instantiation) finish completely
            await OfflineAiService.initializeEngine((progress) {
              debugPrint("Silent AI Engine Warm-up: ${progress.toStringAsFixed(0)}%");
            });
          } catch (e) {
            debugPrint("Background engine wakeup interrupt: $e");
          }
        }
        
        // Broadcast the success signal to unlock text input boxes everywhere instantly
        _aiReadyNotifier.value = OfflineAiService.isReady;
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openAIChatPanel() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIChatPanel(),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          Positioned(
            bottom: 105, 
            right: 20,
            child: GestureDetector(
              onTap: _openAIChatPanel,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 10 + (_pulseController.value * 12),
                          spreadRadius: 2 + (_pulseController.value * 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const BoxDecoration(color: Color(0xFF1A0B2E), shape: BoxShape.circle),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AIChatPanel extends StatefulWidget {
  const AIChatPanel({super.key});

  @override
  State<AIChatPanel> createState() => _AIChatPanelState();
}

class _AIChatPanelState extends State<AIChatPanel> {
  final List<Map<String, String>> _messages = [
    {"sender": "ai", "text": "GREETINGS, HERO! I AM YOUR COMPANION COGNITIVE GUIDE. ASK ME ANY QUESTION TO ENHANCE YOUR MASTERY COUNTER!"}
  ];
  final _chatController = TextEditingController();
  bool _isResponding = false;

  @override
  void initState() {
    super.initState();
    // Connects this panel to the global broadcast channel updates
    _aiReadyNotifier.addListener(_handleAiStatusChange);
  }

  @override
  void dispose() {
    _aiReadyNotifier.removeListener(_handleAiStatusChange);
    _chatController.dispose();
    super.dispose();
  }

  void _handleAiStatusChange() {
    if (mounted) setState(() {}); // Force redraw inside the bottom sheet tree context
  }

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty || _isResponding || !_aiReadyNotifier.value) return;

    SystemSound.play(SystemSoundType.click);
    setState(() {
      _messages.add({"sender": "player", "text": text.toUpperCase()});
      _chatController.clear();
      _isResponding = true;
    });

    final aiResponse = await OfflineAiService.sendChatMessage(text);

    if (mounted) {
      setState(() {
        _messages.add({"sender": "ai", "text": aiResponse.toUpperCase()});
        _isResponding = false;
      });
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    
    // Checks the broadcast notifier value to dynamically alter operational access states
    final bool ready = _aiReadyNotifier.value || OfflineAiService.isReady;

    return Container(
      padding: EdgeInsets.only(bottom: keyboardSpace),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: const BoxDecoration(
        color: Color(0xFF21153B), 
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        border: Border(top: BorderSide(color: Color(0xFF753896), width: 4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: Colors.cyanAccent, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "REALM ASSISTANT",
                  style: TextStyle(fontFamily: 'PressStart2P', color: Colors.cyanAccent, fontSize: 9, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, color: Colors.white54, size: 20), onPressed: () => Navigator.pop(context))
              ],
            ),
          ),
          const Divider(color: Color(0xFF381B4B), thickness: 2),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isAI = msg['sender'] == 'ai';
                return Align(
                  alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAI ? const Color(0xFF381B4B) : const Color(0xFF753896),
                      border: Border.all(color: isAI ? const Color(0xFF4C3075) : const Color(0xFF9E59C9), width: 2),
                    ),
                    child: Text(
                      msg['text'] ?? "",
                      style: TextStyle(fontFamily: 'PressStart2P', color: isAI ? Colors.white : Colors.amberAccent, fontSize: 7.5, height: 1.5),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A0B2E),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: const Color(0xFF21153B),
                    child: TextField(
                      controller: _chatController,
                      enabled: ready,
                      style: TextStyle(fontFamily: 'PressStart2P', color: ready ? Colors.white : Colors.white24, fontSize: 8),
                      decoration: InputDecoration(
                        hintText: ready ? "ASK THE CHRONICLES..." : "READING ARCHIVES...",
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 8),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: ready ? _sendMessage : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: ready ? const Color(0xFF753896) : Colors.white10,
                    child: Icon(Icons.send, color: ready ? Colors.white : Colors.white24, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}