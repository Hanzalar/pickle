import 'package:flutter/foundation.dart';
import 'community_model.dart';

class ProfileModel with ChangeNotifier {
  String playerName = 'John Doe';
  String  username= 'TheRealJohnDoe';
  int age = 28;
  String notes = "Been playing for 3 years. Just moved to Pittsburgh!";
  int wins = 25;
  int losses = 10;
  int playerFaults = 7;
  
  // Define other functionalities as methods here and call notifyListeners() afterwards
  UserModel getDefaultUser() {
  return UserModel(
    id: '33',
    profileImageUrl:'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
    username: username,
    name: playerName,
    age: age,
    notes: notes,
    wins: wins,
    losses: losses,
    playerFaults: playerFaults,
  );
}
  
}


