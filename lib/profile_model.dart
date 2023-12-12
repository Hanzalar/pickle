import 'package:flutter/foundation.dart';

class ProfileModel with ChangeNotifier {
  String playerName = 'John Doe';
  String  username= 'TheRealJohnDoe';
  int age = 28;
  String notes = "Been playing for 3 years. Just moved to Pittsburgh!";
  int wins = 25;
  int losses = 10;
  int playerFaults = 7;
  
  // Define other functionalities as methods here and call notifyListeners() afterwards
}