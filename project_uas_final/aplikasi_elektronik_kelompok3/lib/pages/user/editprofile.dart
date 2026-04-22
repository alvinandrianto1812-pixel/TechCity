import 'dart:io';
import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  File? _imageFile;
  String? _tempUrl;
  Map<String, dynamic>? userProfile;
  bool insertCheck = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String userId = Supabase.instance.client.auth.currentUser!.id;
    final response = await Supabase.instance.client
        .from('Pelanggan')
        .select()
        .eq('id', userId)
        .single();

    if (response['ImageUrl'] == null) {
      insertCheck = true;
    }

    setState(() {
      userProfile = response;
      _usernameController.text = userProfile!['nama'];
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_imageFile != null) {
      await _changeProfilePicture(_imageFile);
    } else {
      _tempUrl = userProfile!['ImageUrl'];
    }
    final userId = supabase.auth.currentUser?.id;

    await supabase
        .from('Pelanggan')
        .update({'nama': _usernameController.text, 'ImageUrl': _tempUrl}).eq(
            'id', userId.toString());

    Navigator.pop(context); // Refresh user profile data
  }

  Future<void> _changeProfilePicture(File? pickedFile) async {
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final userId = supabase.auth.currentUser?.id;
      final fileName = '$userId.jpg';
      final storageResponse;
      if (insertCheck) {
        storageResponse = await supabase.storage
            .from('profilepictures')
            .upload(fileName, imageFile);
      } else {
        storageResponse = await supabase.storage
            .from('profilepictures')
            .update(fileName, imageFile);
      }
      if (storageResponse != null) {
        final imageUrl =
            supabase.storage.from('profilepictures').getPublicUrl(fileName);

        // Update the profile picture URL in the user's profile
        setState(() {
          _tempUrl = imageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFebeaf6),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: const Color(0xFFFFFBEF), // Mengubah warna teks menjadi putih
            fontWeight: FontWeight.bold, // Membuat teks menjadi bold
          ),
        ),
        backgroundColor: const Color(0xFF4A148C), // Warna AppBar
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : userProfile!['ImageUrl'] != null
                                  ? NetworkImage(userProfile!['ImageUrl'])
                                  : const AssetImage('assets/profile.jpg')
                                      as ImageProvider,
                          backgroundColor: Colors.white,
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 40,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color for better visibility
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFFC77864), // Correct property for background color
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5, // Add shadow for more visibility
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
