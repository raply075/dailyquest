import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _nameController = TextEditingController();
  String? _avatarUrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data != null) {
      setState(() {
        _nameController.text = data['full_name'] ?? '';
        _avatarUrl = data['avatar_url'];
      });
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _loading = true);

    final user = _supabase.auth.currentUser!;
    final bytes = await image.readAsBytes();
    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _supabase.storage.from('avatars').uploadBinary(fileName, bytes,
        fileOptions: const FileOptions(upsert: true));

    final publicUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

    await _supabase.from('profiles').upsert({
      'id': user.id,
      'avatar_url': publicUrl,
    });

    setState(() {
      _avatarUrl = publicUrl;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    final user = _supabase.auth.currentUser!;
    final name = _nameController.text.trim();

    await _supabase.from('profiles').upsert({
      'id': user.id,
      'full_name': name,
      'avatar_url': _avatarUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _supabase.auth.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _avatarUrl != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_avatarUrl!),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _uploadAvatar,
                    child: const Text('Ganti Foto'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: 'Nama Lengkap'),
                  ),
                  const SizedBox(height: 10),
                  Text('Email: $userEmail'),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  )
                ],
              ),
            ),
    );
  }
}
