import 'package:flutter/foundation.dart';

class WaitlistEntry {
  final String teamName;
  final int playersInParty;

  WaitlistEntry(this.teamName, this.playersInParty);
}

class CheckinModel with ChangeNotifier {
  String teamName = '';
  int playersInParty = 0;
  int waitlistPosition = 0;
  String currentStatus = 'Empty';
  List<WaitlistEntry> waitlist = [];
  String reservationDate = '';

  void updateTeamName(String name) {
    teamName = name;
    notifyListeners();
  }

  void updatePlayersInParty(int count) {
    playersInParty = count;
    notifyListeners();
  }

  void updateCurrentStatus(String status) {
    currentStatus = status;
    notifyListeners();
  }

  void joinWaitlist() {
    waitlistPosition++;
    waitlist.add(WaitlistEntry(teamName, playersInParty));
    notifyListeners();
  }


  bool isTimeSlotAvailable(int courtNumber, String timeSlot) {
    // only one time available for now
    return courtNumber == 4 && timeSlot == '7:00am - 8:00am';

  }
}
