import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // Add this import for IconData

class GameResult {
  final String outcome;
  final String notes;
  final IconData? icon;

  GameResult(this.outcome, this.notes, this.icon);
}

class PerformanceModel with ChangeNotifier {
  List<GameResult> _gameResults = [];

  List<GameResult> get gameResults => _gameResults;

  void addGameResult(GameResult result) {
    _gameResults.add(result);
    notifyListeners();
  }

}
