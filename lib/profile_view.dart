import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // Background design
                Positioned(
                  top: 20,
                  right: -70,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.07),
                    ),
                  ),
                ),
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
                          child: Icon(Icons.person, size: 100, color: Colors.grey[400]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('@${model.username}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('${model.playerName}', style: TextStyle(fontSize: 22, color: Colors.grey[400])),
                      SizedBox(height: 50),
                     
                      Text(
                        model.notes,
                        style: TextStyle(fontSize: 20, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                        SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          _buildProfileDetail(Icons.emoji_events, 'Wins', '${model.wins}', context),
                          _buildProfileDetail(Icons.disabled_by_default, 'Losses', '${model.losses}', context),
                          _buildProfileDetail(Icons.location_disabled_sharp, 'Faults', '${model.playerFaults}', context),
                        ],
                      ),
                     
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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