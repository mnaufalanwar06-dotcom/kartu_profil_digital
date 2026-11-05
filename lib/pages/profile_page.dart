import 'package:flutter/material.dart';
import '../models/profile_data.dart';
import '../services/pref_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.prefs,
    required this.isDark,
    required this.onThemeChanged,
  });

  final PrefService prefs;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileData _profile;

  @override
  void initState() {
    super.initState();
    // Membaca profil awal dari SharedPreferences
    _profile = widget.prefs.profile; 
  }

  // --- Langkah 1 Lab 5 ---
  Future<void> _reset() async {
    await widget.prefs.clearProfile();
    if (!mounted) return;
    setState(() => _profile = widget.prefs.profile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil dikembalikan ke bawaan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Kartu Profil Digital')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colors.primaryContainer,
                    child: Text(
                      _profile.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_profile.name,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(_profile.title),
                  const SizedBox(height: 12),
                  Text(_profile.bio, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Mode Gelap'),
            value: widget.isDark,
            onChanged: widget.onThemeChanged,
          ),
          const SizedBox(height: 24),
          
          // --- Langkah 2 Lab 5 ---
          OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.restore),
            label: const Text('Reset Profil'),
          ),
          const SizedBox(height: 24),
          
          Center(
            child: Text(
              'Kartu ini sudah dibuka ${widget.prefs.openCount} kali',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}