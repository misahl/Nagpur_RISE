import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../services/ai_chat_service.dart';
import '../../core/constants/app_colors.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final AIChatService _chatService = ContextualFarmChatService();

  final List<String> _suggestedPrompts = [
    'How is my farm?',
    'Which zone needs attention?',
    'Should I irrigate today?',
    'Which area has highest disease risk?',
    'When should I inspect my farm?',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: 'Namaste! I am OrangeAI Assistant. I monitor your 4.2-acre citrus orchard 24/7 with real-time sensors, satellite weather, and AI leaf diagnostics. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final query = text.trim();
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
    });

    _scrollToBottom();

    final farmState = Provider.of<FarmStateProvider>(context, listen: false);
    final response = await _chatService.getResponse(
      query: query,
      farm: farmState.currentFarm,
      zones: farmState.zones,
      soilMoisture: farmState.sensorService.getLatestReading(farmState.currentFarm.id, 'zone_b').soilMoisture,
      rainProbability: farmState.weather.rainProbability,
    );

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.orangeSurface,
              child: Text('🍊', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Farm Assistant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Contextual Agronomist Online', style: TextStyle(fontSize: 11, color: AppColors.healthyGreen)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat history
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: msg.isUser ? AppColors.primaryOrange : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: msg.isUser ? const Radius.circular(16) : const Radius.circular(4),
                        bottomRight: msg.isUser ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: msg.isUser ? Colors.white : AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryOrange),
                  ),
                  const SizedBox(width: 8),
                  Text('OrangeAI checking farm sensors...', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),

          // Quick Suggested Prompts Horizontal Bar
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _suggestedPrompts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.borderSubtle),
                    onPressed: () => _sendMessage(prompt),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Input field row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Ask about irrigation, disease, or yield...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        filled: true,
                        fillColor: AppColors.backgroundLight,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryOrange,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
