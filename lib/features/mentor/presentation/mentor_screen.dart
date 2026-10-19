import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/ambient_background.dart';
import '../../../core/widgets/lime_button.dart';
import '../../../core/widgets/mentor_orb.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

enum _Sender { mentor, user }

class _ChatMessage {
  final _Sender sender;
  final String text;
  final String time;

  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  bool _isTyping = false;

  // Typing indicator animation controllers
  late final List<AnimationController> _dotControllers;
  late final List<Animation<double>> _dotAnims;

  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    // Staggered dot animations for typing indicator
    _dotControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _dotAnims = _dotControllers
        .map(
          (c) => Tween<double>(begin: 0.3, end: 1.0).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    // Stagger start
    for (var i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _dotControllers[i].repeat(reverse: true);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    for (final c in _dotControllers) {
      c.dispose();
    }
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Generic mentor responses based on keywords
  String _getMentorReply(String userMsg) {
    final msg = userMsg.toLowerCase();
    if (msg.contains('skip') || msg.contains('rest')) {
      return 'No skipping. You already know the answer. Get moving.';
    } else if (msg.contains('protein') || msg.contains('eat') || msg.contains('food') || msg.contains('meal')) {
      return 'Eggs, rice, dal, chicken. That\'s your stack. 120g protein daily — non-negotiable. Track it in the log.';
    } else if (msg.contains('workout') || msg.contains('exercise') || msg.contains('train')) {
      return 'Today\'s plan is already set. Chest + Triceps. 6 exercises, 55 minutes. Start the session — no more questions.';
    } else if (msg.contains('water') || msg.contains('hydrat')) {
      return 'You\'re at 1.8L. Target is 3.2L. Drink 500ml right now. No excuses.';
    } else if (msg.contains('sleep') || msg.contains('recover') || msg.contains('rest')) {
      return '7-8 hours. No screen after 10pm. That\'s not a suggestion — it\'s protocol.';
    } else if (msg.contains('weight') || msg.contains('fat') || msg.contains('lose')) {
      return 'You\'re at 74.5kg. 2.4kg from goal. Stay in deficit 200kcal/day. The math doesn\'t care about your feelings.';
    } else if (msg.contains('muscle') || msg.contains('gain') || msg.contains('bulk')) {
      return 'Progressive overload. Add 2.5kg every week when you hit all reps. Simple. Boring. Works.';
    } else if (msg.contains('motivation') || msg.contains('tired') || msg.contains('lazy')) {
      return 'Motivation is for amateurs. You\'re building discipline. Show up. Do the work. Leave.';
    } else if (msg.contains('progress') || msg.contains('result')) {
      return '12 days streak. 94% compliance. You\'re doing the work. Results take 12 weeks, not 12 days. Keep going.';
    } else {
      const replies = [
        'Focus. What\'s the actual question? Ask me something specific.',
        'Stop overthinking. What\'s your next action right now?',
        'Noted. Now go train. The gym is waiting.',
        'That\'s handled. Stay on protocol. One day at a time.',
        'Your plan is set. Trust the process. Execute.',
      ];
      return replies[DateTime.now().millisecond % replies.length];
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        sender: _Sender.user,
        text: text,
        time: _currentTime(),
      ));
      _inputController.clear();
      _isTyping = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          sender: _Sender.mentor,
          text: _getMentorReply(text),
          time: _currentTime(),
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Get the bottom inset for the nav bar (80px nav bar + safe area)
    final bottomPad = MediaQuery.of(context).padding.bottom + 80;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: AmbientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              const Divider(color: Color(0x0DFFFFFF), height: 1, thickness: 1),
              Expanded(child: _buildChatArea(bottomPad)),
              _buildSuggestionChips(),
              _buildInputDock(bottomPad),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Center: orb + title
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const MentorOrb(size: 36),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your Mentor',
                      style: AppText.body.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    Text(
                      'FORGE AI',
                      style: AppText.label.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right badge
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: AppColors.lime.withValues(alpha: 0.30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: AppColors.lime,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Strict Coach',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lime,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Chat area ─────────────────────────────────────────────────────────────

  Widget _buildChatArea(double bottomPad) {
    if (_messages.isEmpty && !_isTyping) {
      return _buildWelcomeState(bottomPad);
    }
    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad + 16),
      children: [
        // Date badge
        Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              'Today',
              style: AppText.label.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Messages
        ..._messages.map((msg) => _buildMessage(msg)),
        // Typing indicator
        if (_isTyping) _buildTypingIndicator(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildWelcomeState(double bottomPad) {
    const prompts = [
      (Icons.fitness_center_rounded, 'Create a workout plan'),
      (Icons.restaurant_rounded, 'High protein meals'),
      (Icons.bar_chart_rounded, 'Build muscle faster?'),
      (Icons.bedtime_rounded, 'Sleep & recovery tips'),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPad + 16),
      children: [
        // Orb + title
        Center(child: SizedBox(width: 80, height: 80, child: MentorOrb(size: 80))),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Ask Your AI Coach',
            style: AppText.h2.copyWith(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Get personalized workout plans, nutrition tips\nand answers to your fitness questions.',
            style: AppText.label.copyWith(fontSize: 12, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        // Quick prompts — 2 rows of 2
        Row(
          children: [
            Expanded(child: _promptCard(prompts[0].$1, prompts[0].$2)),
            const SizedBox(width: 10),
            Expanded(child: _promptCard(prompts[1].$1, prompts[1].$2)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _promptCard(prompts[2].$1, prompts[2].$2)),
            const SizedBox(width: 10),
            Expanded(child: _promptCard(prompts[3].$1, prompts[3].$2)),
          ],
        ),
        const SizedBox(height: 20),
        // Initial mentor message
        _buildMessage(const _ChatMessage(
          sender: _Sender.mentor,
          text: 'Hi Tanzim! 👋\nWhat\'s your main goal today?\nYou can ask me anything about workouts, nutrition, or recovery.',
          time: '9:41 AM',
        )),
      ],
    );
  }

  Widget _promptCard(IconData icon, String text) {
    return GestureDetector(
      onTap: () => _inputController.text = text,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.05),
              Colors.white.withValues(alpha: 0.01),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.lime.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.lime.withValues(alpha: 0.20)),
              ),
              child: Icon(icon, size: 16, color: AppColors.lime),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE5E5E5),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(_ChatMessage msg) {
    final isMentor = msg.sender == _Sender.mentor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isMentor ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isMentor ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isMentor) ...[_buildMentorAvatar(), const SizedBox(width: 8)],
              Flexible(
                child: isMentor
                    ? _buildMentorBubble(msg)
                    : _buildUserBubble(msg),
              ),
              if (!isMentor) ...[const SizedBox(width: 8), _buildUserAvatar()],
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: isMentor
                ? const EdgeInsets.only(left: 36)
                : const EdgeInsets.only(right: 36),
            child: Text(
              msg.time,
              style: AppText.label.copyWith(
                fontSize: 10,
                color: isMentor
                    ? AppColors.textSecondary
                    : AppColors.onLime.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorAvatar() {
    return const SizedBox(
      width: 28,
      height: 28,
      child: MentorOrb(size: 28),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.lime,
      child: Text(
        'T',
        style: AppText.label.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.onLime,
        ),
      ),
    );
  }

  Widget _buildMentorBubble(_ChatMessage msg) {
    return IntrinsicWidth(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Lime left border
          Container(
            width: 2,
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                bottomLeft: Radius.circular(2),
              ),
            ),
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111A14).withValues(alpha: 0.82),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMentorText(msg.text),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorText(String text) {
    // First line bold, rest normal
    final lines = text.split('\n');
    if (lines.length > 1) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: lines.first,
              style: AppText.body.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: '\n${lines.sublist(1).join("\n")}',
              style: AppText.body.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    return Text(
      text,
      style: AppText.body.copyWith(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 14,
      ),
    );
  }

  // ignore: unused_element
  Widget _buildChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1F12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lime.withValues(alpha: 0.30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.emoji_events_rounded,
                size: 20,
                color: AppColors.lime,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHALLENGE',
                      style: AppText.label.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lime.withValues(alpha: 0.8),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '100 Push-Ups',
                      style: AppText.body.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Complete before end of day',
                      style: AppText.label.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LimeButton(
            label: 'Mark done',
            onPressed: () {},
            height: 36,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(_ChatMessage msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Text(
        msg.text,
        style: AppText.body.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onLime,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildMentorAvatar(),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111A14).withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: FadeTransition(
                        opacity: _dotAnims[i],
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Suggestion chips ──────────────────────────────────────────────────────

  Widget _buildSuggestionChips() {
    const chips = [
      'Cheap protein ideas',
      'Skip today?',
      'Check my week',
      'My weak points',
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) => _SuggestionChip(
          label: chips[i],
          onTap: () {
            _inputController.text = chips[i];
          },
        ),
      ),
    );
  }

  // ─── Footer / input dock ───────────────────────────────────────────────────

  Widget _buildInputDock(double bottomPad) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF162119).withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFF2D4A35)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded, size: 20, color: AppColors.textSecondary),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        style: AppText.body.copyWith(fontSize: 13, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ask your mentor...',
                          hintStyle: AppText.body.copyWith(fontSize: 13, color: AppColors.textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mic_rounded, size: 20, color: AppColors.textSecondary),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lime,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lime.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_upward_rounded, size: 18, color: AppColors.onLime),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Spacing above nav bar
        SizedBox(height: bottomPad + 8),
      ],
    );
  }
}

// ─── Suggestion Chip widget ───────────────────────────────────────────────────

class _SuggestionChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _pressed
                  ? AppColors.lime.withValues(alpha: 0.40)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
