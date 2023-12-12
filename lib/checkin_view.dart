// checkin_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkin_model.dart';

class CheckinView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckinModel>(
      builder: (context, checkinModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Check In'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(labelText: 'Team Name'),
                  onChanged: (value) => checkinModel.updateTeamName(value),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => _showStatusDialog(context, checkinModel),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Current Status: ${checkinModel.currentStatus}', style: TextStyle(fontSize: 25)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => checkinModel.updatePlayersInParty(checkinModel.playersInParty - 1),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text('${checkinModel.playersInParty}', style: TextStyle(fontSize: 25)),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => checkinModel.updatePlayersInParty(checkinModel.playersInParty + 1),
                      iconSize: 40,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    checkinModel.joinWaitlist();
                    _showWaitlistDialog(context, checkinModel);
                  },
                  child: Text('Join Waitlist', style: TextStyle(fontSize: 25)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectDate(context, checkinModel),
                  child: Text('Select Date', style: TextStyle(fontSize: 25)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showReservationDialog(context, checkinModel),
                  child: Text('Reserve a Court', style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStatusDialog(BuildContext context, CheckinModel checkinModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Set Status'),
          children: [
            _buildStatusOption(context, checkinModel, 'Busy'),
            _buildStatusOption(context, checkinModel, 'Moderate'),
            _buildStatusOption(context, checkinModel, 'Not Busy'),
          ],
        );
      },
    );
  }

  Widget _buildStatusOption(BuildContext context, CheckinModel checkinModel, String status) {
    return InkWell(
      onTap: () {
        checkinModel.updateCurrentStatus(status);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(status),
      ),
    );
  }

  void _showWaitlistDialog(BuildContext context, CheckinModel checkinModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Join Waitlist'),
          children: [
            Text('You\'re ${checkinModel.waitlistPosition} in line'),
            SizedBox(height: 16),
            Text('Waitlist:'),
            for (int i = 0; i < checkinModel.waitlist.length; i++)
              _buildWaitlistItem(context, checkinModel.waitlist[i], i + 1),
          ],
        );
      },
    );
  }

  Widget _buildWaitlistItem(BuildContext context, WaitlistEntry entry, int position) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            '$position. ${entry.teamName} - Party Size: ${entry.playersInParty}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, CheckinModel checkinModel) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Format the date as needed
      String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      checkinModel.reservationDate = formattedDate;
    }
  }

  void _showReservationDialog(BuildContext context, CheckinModel checkinModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reserve a Court'),
          content: Column(
            children: [
              Text('Want to reserve a court for another day? Reserve it here!'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showTimeSlotsDialog(context, checkinModel),
                child: Text('Reserve Court', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimeSlotsDialog(BuildContext context, CheckinModel checkinModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Slots Available'),
          content: Column(
            children: [
              _buildTimeSlot(context, checkinModel, '7:00am - 8:00am', 4),
              _buildTimeSlot(context, checkinModel, '8:00am - 9:00am', 1),
              _buildTimeSlot(context, checkinModel, '9:00am - 10:00am', 2),
              _buildTimeSlot(context, checkinModel, '10:00am - 11:00am', 3),
              _buildTimeSlot(context, checkinModel, '11:00am - 12:00pm', 4),
              _buildTimeSlot(context, checkinModel, '12:00pm - 1:00pm', 1),
              _buildTimeSlot(context, checkinModel, '1:00pm - 2:00pm', 2),
              _buildTimeSlot(context, checkinModel, '2:00pm - 3:00pm', 3),
              _buildTimeSlot(context, checkinModel, '3:00pm - 4:00pm', 1),
              _buildTimeSlot(context, checkinModel, '4:00pm - 5:00pm', 2),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeSlot(BuildContext context, CheckinModel checkinModel, String timeSlot, int courtNumber) {
    bool isAvailable = checkinModel.isTimeSlotAvailable(courtNumber, timeSlot);
    return InkWell(
      onTap: () {
        if (isAvailable) {
          _showConfirmationDialog(context, checkinModel, timeSlot, courtNumber);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
            fontSize: 20,
            color: isAvailable ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, CheckinModel checkinModel, String timeSlot, int courtNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reservation Confirmation'),
          content: Text(
            'Confirmed for ${checkinModel.teamName} for ${checkinModel.playersInParty} players on ${checkinModel.reservationDate} at $timeSlot on Court $courtNumber',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
