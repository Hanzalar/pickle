import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ScoreModel with ChangeNotifier {
int teamOneScore = 0;
int teamTwoScore = 0;
int currentServe = 2;
int servingTeam = 1;
bool isFirstServer = true;
String winningTeam = '';
bool isGameOver = false; 

  void incrementScore() {
    if (teamOneScore >= 11) {
        // Update winning team and game over state then notify listeners
        winningTeam = 'Team One Wins!';
        isGameOver = true;
        print("games over");
        notifyListeners();
    } else if (teamTwoScore >= 11) {
        // Update winning team and game over state then notify listeners
        winningTeam = 'Team Two Wins!';
        isGameOver = true;
         print("games over");
        notifyListeners();
    } else if (servingTeam == 1 && teamOneScore <=10 && teamTwoScore <=10) {
      teamOneScore++;
      notifyListeners();
    } else if (servingTeam == 2 && teamOneScore <=10 && teamTwoScore <=10) {
      teamTwoScore++;
      notifyListeners();
    }
}

 // refer to the previous explanation about showDialog implementation

void resetGame() {
    teamOneScore = 0;
    teamTwoScore = 0;
    currentServe = 2;
    servingTeam = 1;
    isFirstServer = true;
    isGameOver = false; 
    notifyListeners();
}

  void switchServer() {
    if (currentServe == 1) {
      currentServe = 2;
    } else {
      servingTeam = servingTeam == 1 ? 2 : 1;
      currentServe = 1;
    }
    isFirstServer = !isFirstServer;
    notifyListeners();  
  }

  void undoLastAction() {
    // Add your undo logic here
    // Don't forget to call `notifyListeners()`
  }

}