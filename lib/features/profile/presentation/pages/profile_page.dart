import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodtune/services/dependencies/di.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';
import 'package:moodtune/features/profile/presentation/bloc/profie_bloc.dart';
import 'package:moodtune/features/profile/presentation/constants/music_genres.dart';
import 'package:moodtune/core/themes/_themes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _singerController;

  late ProfileBloc _bloc;
  late StreamSubscription<ProfileState> _subscription;

  String? _profileImagePath;
  List<String> _selectedGenres = [];
  List<String> _favoriteSingers = [];
  bool _isEditMode = false;
  bool _isFirstTime = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _singerController = TextEditingController();

    _bloc = get<ProfileBloc>();
    _subscription = _bloc.stream.listen((state) {
      print('ProfilePage - State received: ${state.runtimeType}');
      if (mounted) {
        if (state is ProfileLoaded) {
          print('ProfilePage - Profile loaded: ${state.profile.name}');
          _updateControllers(state.profile);
        } else if (state is ProfileUpdateSuccess) {
          if (mounted) {
            setState(() {
              _isEditMode = false;
              _isFirstTime = false;
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile saved successfully!'),
                backgroundColor: BaseColors.gold3,
              ),
            );
            _bloc.add(FetchProfile());
          }
        } else if (state is ProfileError) {
          print('ProfilePage - Error: ${state.message}');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else if (state is ProfileLoading) {
          print('ProfilePage - Loading...');
          if (mounted) {
            setState(() {
              _isLoading = true;
            });
          }
        }
      }
    });

    print('ProfilePage - Adding FetchProfile event');
    _bloc.add(FetchProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _singerController.dispose();
    _subscription.cancel();
    // Don't close the bloc here as it's managed by GetIt DI
    // _bloc.close();
    super.dispose();
  }

  void _updateControllers(Profile profile) {
    if (mounted) {
      setState(() {
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _usernameController.text = profile.username;
        _profileImagePath = profile.profilePicturePath;
        _selectedGenres = List.from(profile.favoriteGenres);
        _favoriteSingers = List.from(profile.favoriteSingers);
        _isFirstTime = !profile.isProfileComplete;
        _isEditMode = _isFirstTime;
        _isLoading = false; // Important: stop loading when profile is loaded
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  void _addSinger() {
    if (_singerController.text.trim().isNotEmpty) {
      setState(() {
        _favoriteSingers.add(_singerController.text.trim());
        _singerController.clear();
      });
    }
  }

  void _removeSinger(int index) {
    setState(() {
      _favoriteSingers.removeAt(index);
    });
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        profilePicturePath: _profileImagePath,
        favoriteSingers: _favoriteSingers,
        favoriteGenres: _selectedGenres,
        isProfileComplete: true,
      );

      _bloc.add(UpdateProfileData(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: BaseColors.gold3),
            )
          : _isFirstTime
          ? _buildSetupProfile()
          : _buildProfileView(),
    );
  }

  Widget _buildSetupProfile() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Welcome Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [BaseColors.gold3, BaseColors.goldenrod],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.music_note, size: 48, color: BaseColors.white),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to MoodTune!',
                    style: FontTheme.poppins24w700black().copyWith(
                      color: BaseColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s set up your profile to personalize your music experience',
                    style: FontTheme.poppins14w400black().copyWith(
                      color: BaseColors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Setup Form
            _buildProfileForm(isSetup: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [BaseColors.gold3, BaseColors.goldenrod],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Profile Picture (only show in view mode, not edit mode)
                  if (!_isEditMode)
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: BaseColors.white,
                          backgroundImage: _profileImagePath != null
                              ? FileImage(File(_profileImagePath!))
                              : null,
                          child: _profileImagePath == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: BaseColors.gray3,
                                )
                              : null,
                        ),
                      ],
                    ),

                  // In edit mode, show smaller profile indicator
                  if (_isEditMode)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BaseColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 40,
                        color: BaseColors.white,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Name and Username
                  Text(
                    _nameController.text.isEmpty
                        ? 'Your Name'
                        : _nameController.text,
                    style: FontTheme.poppins24w700black().copyWith(
                      color: BaseColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${_usernameController.text.isEmpty ? 'username' : _usernameController.text}',
                    style: FontTheme.poppins16w400black().copyWith(
                      color: BaseColors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit Button
                  if (!_isEditMode)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditMode = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BaseColors.white,
                        foregroundColor: BaseColors.gold3,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          const Text('Edit Profile'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Content
            if (_isEditMode)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildProfileForm(isSetup: false),
              )
            else
              _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm({required bool isSetup}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isSetup) ...[
            // Profile Picture Section (for edit mode)
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: BaseColors.gray1,
                    backgroundImage: _profileImagePath != null
                        ? FileImage(File(_profileImagePath!))
                        : null,
                    child: _profileImagePath == null
                        ? Icon(Icons.person, size: 50, color: BaseColors.gray3)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: BaseColors.gold3,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Basic Info Section
          _buildSectionTitle('Basic Information'),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _usernameController,
            label: 'Username',
            icon: Icons.alternate_email,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Username is required';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Music Preferences Section
          _buildSectionTitle('Music Preferences'),
          const SizedBox(height: 16),

          // Favorite Singers
          _buildSubSectionTitle('Favorite Singers'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _singerController,
                  label: 'Add a singer',
                  icon: Icons.mic,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _addSinger,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColors.gold3,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Singers Chips
          if (_favoriteSingers.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _favoriteSingers.asMap().entries.map((entry) {
                int index = entry.key;
                String singer = entry.value;
                return Chip(
                  label: Text(singer),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeSinger(index),
                  backgroundColor: BaseColors.goldenrod.withOpacity(0.2),
                  deleteIconColor: BaseColors.gold3,
                );
              }).toList(),
            ),
          const SizedBox(height: 24),

          // Favorite Genres
          _buildSubSectionTitle('Favorite Genres'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MusicGenres.genres.map((genre) {
              bool isSelected = _selectedGenres.contains(genre);
              return FilterChip(
                label: Text(genre),
                selected: isSelected,
                onSelected: (_) => _toggleGenre(genre),
                backgroundColor: Colors.grey[100],
                selectedColor: BaseColors.goldenrod.withOpacity(0.3),
                checkmarkColor: BaseColors.gold3,
                labelStyle: TextStyle(
                  color: isSelected ? BaseColors.gold3 : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),

          // Save Button
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: BaseColors.gold3,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              isSetup ? 'Complete Setup' : 'Save Changes',
              style: FontTheme.poppins16w500black().copyWith(
                color: Colors.white,
              ),
            ),
          ),

          if (!isSetup) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditMode = false;
                });
              },
              child: Text(
                'Cancel',
                style: FontTheme.poppins14w400black().copyWith(
                  color: BaseColors.gray3,
                ),
              ),
            ),
          ],

          // Extra bottom padding to avoid navbar overlap
          SizedBox(height: isSetup ? 100 : 80),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Info Card
          _buildInfoCard(
            title: 'Basic Information',
            children: [
              _buildInfoRow('Email', _emailController.text),
              _buildInfoRow('Username', '@${_usernameController.text}'),
            ],
          ),
          const SizedBox(height: 24),

          // Music Preferences Card
          _buildInfoCard(
            title: 'Music Preferences',
            children: [
              if (_favoriteSingers.isNotEmpty) ...[
                _buildInfoSection('Favorite Singers', _favoriteSingers),
                const SizedBox(height: 16),
              ],
              if (_selectedGenres.isNotEmpty)
                _buildInfoSection('Favorite Genres', _selectedGenres),
            ],
          ),

          // Extra bottom padding to avoid navbar overlap
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: BaseColors.gold3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: BaseColors.gray2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: BaseColors.gold3, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: FontTheme.poppins18w500black().copyWith(color: BaseColors.gold3),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Text(title, style: FontTheme.poppins16w500black());
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FontTheme.poppins18w500black().copyWith(
              color: BaseColors.gold3,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: FontTheme.poppins14w400black().copyWith(
                color: BaseColors.gray3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: FontTheme.poppins14w500black(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FontTheme.poppins14w400black().copyWith(
            color: BaseColors.gray3,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: BaseColors.goldenrod.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: BaseColors.goldenrod.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    item,
                    style: FontTheme.poppins12w500black().copyWith(
                      color: BaseColors.gold3,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
