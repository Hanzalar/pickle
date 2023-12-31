import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';
import 'community_model.dart';

class ProfileView extends StatelessWidget {
  final UserModel? user;

   ProfileView({this.user});

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = user ?? Provider.of<ProfileModel>(context, listen: false).getDefaultUser();
    
return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),  // pop current page
              )
            : null,  // disable back button when not applicable
        title: Text(currentUser.username),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background design
     
            Positioned(
              bottom: 0,
              left: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.07),
                ),
              ),
            ),
            // Profile contents
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                        backgroundImage: currentUser.profileImageUrl.isNotEmpty
                            ? NetworkImage(currentUser.profileImageUrl)
                            : null,
                        child: currentUser.profileImageUrl.isNotEmpty
                            ? null
                            : Icon(Icons.person, size: 100, color: Colors.grey[400]),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('@${currentUser.username}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('${currentUser.name}', style: TextStyle(fontSize: 22, color: Colors.grey[400])),
                  SizedBox(height: 50),

                  Text(
                    currentUser.notes,
                    style: TextStyle(fontSize: 20, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileDetail(Icons.emoji_events, 'Wins', '${currentUser.wins}', context),
                      _buildProfileDetail(Icons.disabled_by_default, 'Losses', '${currentUser.losses}', context),
                      _buildProfileDetail(Icons.location_disabled_sharp, 'Faults', '${currentUser.playerFaults}', context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(IconData icon, String title, String content, BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}