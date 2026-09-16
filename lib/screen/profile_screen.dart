import 'package:dummyjson/model/user_profile.dart';
import 'package:dummyjson/services/auth_service.dart';
import 'package:dummyjson/services/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final authService = context.read<AuthService>();
    final userId = authService.id;

    if (userId == null) {
      return;
    }

    final result = await UserProfileService().fetchUserProfile(userId);

    if (!mounted) return;

    setState(() {
      profile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final details = [
      ["Email", profile!.email],
      ["Phone", profile!.phone],
      ["Username", profile!.username],
      ["Birth Date", profile!.birthDate],
      ["Blood Group", profile!.bloodGroup],
      ["Eye Color", profile!.eyeColor],
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("My Profile"),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),

              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profile!.image!),
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Text(
                  "${profile!.firstName} ${profile!.lastName}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: Text(
                  "@${profile!.username}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ListView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: details.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ListTile(
                        title: Text(details[index][0]!),
                        subtitle: Text(details[index][1]!),
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}