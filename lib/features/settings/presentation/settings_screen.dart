import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/supabase_client.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/ambient_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/lime_button.dart';
import '../../mentor/data/mentor_repository.dart';

/// OpenRouter model options: id (stored) + display label.
const _openRouterModels = <Map<String, String>>[
  {'id': 'google/gemini-flash-1.5', 'label': 'google/gemini-flash-1.5 (Free)'},
  {'id': 'google/gemini-pro-1.5', 'label': 'google/gemini-pro-1.5 (Paid)'},
  {
    'id': 'meta-llama/llama-3.1-8b-instruct',
    'label': 'meta-llama/llama-3.1-8b-instruct (Free)'
  },
  {
    'id': 'mistralai/mistral-7b-instruct',
    'label': 'mistralai/mistral-7b-instruct (Free)'
  },
  {'id': 'anthropic/claude-3-haiku', 'label': 'anthropic/claude-3-haiku (Paid)'},
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _provider = 'gemini';
  late final TextEditingController _geminiKeyCtrl;
  late final TextEditingController _openrouterKeyCtrl;
  String _selectedModel = 'google/gemini-flash-1.5';
  bool _showGeminiKey = false;
  bool _showOrKey = false;
  bool _isTesting = false;
  bool _isSaving = false;
  String _displayName = 'FORGE Athlete';

  @override
  void initState() {
    super.initState();
    _geminiKeyCtrl = TextEditingController();
    _openrouterKeyCtrl = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final provider = await LocalStorageService.getAiProvider();
    final geminiKey = await LocalStorageService.getGeminiKey();
    final orKey = await LocalStorageService.getOpenRouterKey();
    final model = await LocalStorageService.getOpenRouterModel();
    final profile = await LocalStorageService.loadProfile();
    final name = (profile?['name'] as String?)?.trim();
    if (!mounted) return;
    setState(() {
      _provider = provider;
      _geminiKeyCtrl.text = geminiKey;
      _openrouterKeyCtrl.text = orKey;
      _selectedModel = model;
      if (name != null && name.isNotEmpty) _displayName = name;
    });
  }

  @override
  void dispose() {
    _geminiKeyCtrl.dispose();
    _openrouterKeyCtrl.dispose();
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _snack(String message, {bool success = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF142417),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
              color: success ? AppColors.lime : AppColors.danger,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppText.body.copyWith(
                  color: success ? AppColors.lime : AppColors.danger,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _snack('Could not open link', success: false);
    }
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.lime,
          letterSpacing: 0.08 * 11,
        ),
      ),
    );
  }

  Widget _buildRadioIndicator({required bool isSelected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.lime : const Color(0xFF0C130E),
        border: isSelected
            ? null
            : Border.all(color: const Color(0xFF334638), width: 2),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: AppColors.onLime)
          : null,
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.lime.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.lime.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _buildRadioIndicator(isSelected: selected),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInfoRow(String text, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Row(
        children: [
          Icon(Icons.link_rounded, color: AppColors.lime, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Get free key at $text',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lime,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.lime.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String placeholder,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0E1611),
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              hintText: placeholder,
              hintStyle: TextStyle(color: AppColors.textDisabled, fontSize: 13),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'e.g. $hint',
            style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
          ),
        ),
      ],
    );
  }

  Widget _buildStepGuide(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                s,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _testConnection() async {
    if (_isTesting) return;
    setState(() => _isTesting = true);
    try {
      final repo = MentorRepository();
      final result = await repo.sendMessage('Hello');
      final reply = result['reply'] as String? ?? '';
      if (reply.isNotEmpty) {
        _snack('Connection successful');
      } else {
        _snack('No response from AI', success: false);
      }
    } catch (e) {
      _snack('Connection failed: $e', success: false);
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  Future<void> _saveGeminiKey() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await LocalStorageService.saveGeminiKey(_geminiKeyCtrl.text.trim());
      if (mounted) _snack('Gemini key saved');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveOpenRouterKey() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await LocalStorageService.saveOpenRouterKey(
        _openrouterKeyCtrl.text.trim(),
      );
      if (mounted) _snack('OpenRouter key saved');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _displayName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1A10),
        title: const Text(
          'Display Name',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lime.withValues(alpha: 0.5)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.lime),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text('Save', style: TextStyle(color: AppColors.lime)),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result.isNotEmpty) {
      final profile = await LocalStorageService.loadProfile() ?? {};
      profile['name'] = result;
      await LocalStorageService.saveProfile(profile);
      if (!mounted) return;
      setState(() => _displayName = result);
      _snack('Name updated');
    }
  }

  Future<void> _resetOnboarding() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1A10),
        title: const Text(
          'Reset Onboarding?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This clears your local profile and restarts onboarding.',
          style: TextStyle(color: Color(0xFF9AA39C)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Reset', style: TextStyle(color: AppColors.warning)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await LocalStorageService.clear();
      if (!mounted) return;
      context.go('/onboarding');
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    if (!mounted) return;
    setState(() {});
    _snack('Signed out');
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1A10),
        title: const Text(
          'Delete Account?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Account deletion is not available yet in this phase.',
          style: TextStyle(color: Color(0xFF9AA39C)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('OK', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _snack('Account deletion coming soon', success: false);
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: 144,
                ),
                children: [
                  _buildSectionLabel('AI Mentor'),
                  _buildProviderCard(),
                  const SizedBox(height: 28),
                  _buildSectionLabel('API Key Setup'),
                  _provider == 'openrouter'
                      ? _buildOpenRouterKeyCard()
                      : _buildGeminiKeyCard(),
                  const SizedBox(height: 28),
                  _buildSectionLabel('Profile'),
                  _buildProfileCard(),
                  const SizedBox(height: 28),
                  _buildSectionLabel('App'),
                  _buildAppCard(),
                  const SizedBox(height: 28),
                  _buildSectionLabel('Account'),
                  _buildAccountCard(),
                  const SizedBox(height: 28),
                  _buildSectionLabel('About'),
                  _buildAboutCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.bgDeep.withValues(alpha: 0.85),
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0x0DFFFFFF), width: 1),
            ),
          ),
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF151D17),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 24,
                    color: Color(0xE6FFFFFF),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Balance spacer so the title stays centered (no right button).
              const SizedBox(width: 52),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section 1: AI Provider ─────────────────────────────────────────────────

  Widget _buildProviderCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Provider',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Choose your AI engine',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          _buildOptionTile(
            icon: Icons.auto_awesome,
            iconColor: AppColors.lime,
            title: 'Gemini',
            subtitle: 'Google AI - Free tier available',
            selected: _provider == 'gemini',
            onTap: () {
              setState(() => _provider = 'gemini');
              LocalStorageService.saveAiProvider('gemini');
            },
          ),
          const SizedBox(height: 10),
          _buildOptionTile(
            icon: Icons.hub_rounded,
            iconColor: const Color(0xFFFF8C00),
            title: 'OpenRouter',
            subtitle: 'Access 100+ models',
            selected: _provider == 'openrouter',
            onTap: () {
              setState(() => _provider = 'openrouter');
              LocalStorageService.saveAiProvider('openrouter');
            },
          ),
        ],
      ),
    );
  }

  // ─── Section 2a: Gemini key ─────────────────────────────────────────────────

  Widget _buildGeminiKeyCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gemini API Key',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          _buildKeyInfoRow('aistudio.google.com', 'https://aistudio.google.com'),
          const SizedBox(height: 14),
          _buildKeyField(
            controller: _geminiKeyCtrl,
            obscure: !_showGeminiKey,
            onToggle: () => setState(() => _showGeminiKey = !_showGeminiKey),
            placeholder: 'Paste your Gemini API key here',
            hint: 'AQ.Ab... or AIza...',
          ),
          const SizedBox(height: 14),
          _buildStepGuide(const [
            '1. Go to aistudio.google.com',
            '2. Click Get API key then Create API key',
            '3. Copy the key, which starts with AQ. or AIza',
            '4. Paste above and tap Save',
          ]),
          const SizedBox(height: 16),
          LimeButton.outline(
            label: _isTesting ? 'Testing…' : 'Test Connection',
            onPressed: _isTesting ? null : _testConnection,
          ),
          const SizedBox(height: 10),
          LimeButton(
            label: _isSaving ? 'Saving…' : 'Save Key',
            onPressed: _isSaving ? null : _saveGeminiKey,
          ),
        ],
      ),
    );
  }

  // ─── Section 2b: OpenRouter key ──────────────────────────────────────────────

  Widget _buildOpenRouterKeyCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OpenRouter API Key',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          _buildKeyInfoRow('openrouter.ai', 'https://openrouter.ai'),
          const SizedBox(height: 14),
          _buildKeyField(
            controller: _openrouterKeyCtrl,
            obscure: !_showOrKey,
            onToggle: () => setState(() => _showOrKey = !_showOrKey),
            placeholder: 'Paste your OpenRouter API key here',
            hint: 'sk-or-v1-...',
          ),
          const SizedBox(height: 14),
          Text(
            'Model',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          _buildModelSelector(),
          const SizedBox(height: 14),
          _buildStepGuide(const [
            '1. Go to openrouter.ai',
            '2. Sign up then go to API Keys',
            '3. Create a new key',
            '4. Paste above, select model, tap Save',
          ]),
          const SizedBox(height: 16),
          LimeButton.outline(
            label: _isTesting ? 'Testing…' : 'Test Connection',
            onPressed: _isTesting ? null : _testConnection,
          ),
          const SizedBox(height: 10),
          LimeButton(
            label: _isSaving ? 'Saving…' : 'Save Key',
            onPressed: _isSaving ? null : _saveOpenRouterKey,
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1611),
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedModel,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          border: InputBorder.none,
        ),
        dropdownColor: const Color(0xFF0E1611),
        style: const TextStyle(color: Colors.white, fontSize: 13),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textSecondary,
          size: 20,
        ),
        items: _openRouterModels
            .map(
              (m) => DropdownMenuItem<String>(
                value: m['id'],
                child: Text(
                  m['label']!,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedModel = value);
            LocalStorageService.saveOpenRouterModel(value);
          }
        },
      ),
    );
  }

  // ─── Section 3: Profile ──────────────────────────────────────────────────────

  Widget _buildProfileCard() {
    return GlassCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.limeDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person_rounded, color: AppColors.lime),
            ),
            title: const Text(
              'Display Name',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              _displayName,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onTap: _editName,
          ),
          Divider(
            color: Colors.white.withValues(alpha: 0.06),
            height: 24,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restart_alt_rounded, color: AppColors.warning),
            ),
            title: const Text(
              'Reset Onboarding',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
            subtitle: Text(
              'Clear local data and restart',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warning,
              size: 20,
            ),
            onTap: _resetOnboarding,
          ),
        ],
      ),
    );
  }

  // ─── Section 4: App ─────────────────────────────────────────────────────────

  Widget _buildAppCard() {
    return GlassCard(
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: true,
            onChanged: null,
            activeThumbColor: AppColors.lime,
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Locked for this build',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.lime),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _chip('Always on'),
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.language_rounded, color: Colors.white),
            ),
            title: const Text(
              'Language',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'English',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            onTap: () => _snack('Coming Soon', success: false),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: false,
            onChanged: null,
            activeThumbColor: AppColors.lime,
            title: const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Coming soon',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            secondary: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.lime.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.lime,
        ),
      ),
    );
  }

  // ─── Section 5: Account ─────────────────────────────────────────────────────

  Widget _buildAccountCard() {
    final loggedIn = supabase.auth.currentSession != null;
    return GlassCard(
      child: Column(
        children: [
          if (!loggedIn)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.login_rounded, color: AppColors.lime),
              ),
              title: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onTap: () => context.go('/auth'),
            ),
          if (!loggedIn)
            Divider(color: Colors.white.withValues(alpha: 0.06), height: 24),
          if (loggedIn)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.white),
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onTap: _signOut,
            ),
          if (loggedIn)
            Divider(color: Colors.white.withValues(alpha: 0.06), height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.danger,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.danger,
              size: 20,
            ),
            onTap: _deleteAccount,
          ),
        ],
      ),
    );
  }

  // ─── Section 6: About ────────────────────────────────────────────────────────

  Widget _buildAboutRow(String label, String value,
      {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
      trailing: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 6), trailing],
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard() {
    return GlassCard(
      child: Column(
        children: [
          _buildAboutRow(
            'Version',
            'FORGE v0.1.0 - Phase 1 Complete',
          ),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 8),
          _buildAboutRow(
            'GitHub',
            'github.com/mrtanzim/FitStride',
            trailing: Icon(Icons.open_in_new, size: 16, color: AppColors.lime),
            onTap: () => _launchUrl('https://github.com/mrtanzim/FitStride'),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 8),
          _buildAboutRow('Made with', 'Flutter + Supabase + Gemini'),
        ],
      ),
    );
  }
}
