import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScoreTracker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScoreTracker extends StatefulWidget {
  @override
  _ScoreTrackerState createState() => _ScoreTrackerState();
  
}


class _ScoreTrackerState extends State<ScoreTracker> {
  int teamOneScore = 0;
  int teamTwoScore = 0;
  int currentServe = 2; // Start with the second server
  int servingTeam = 1; // Team One starts serving
  bool isFirstServer = true; // Track if it's the first server
  int _selectedIndex = 0;

  void incrementScore() {
  setState(() {
    if (teamOneScore >= 10) {
        showWinningDialog('Team One Wins!');
      }
      if (teamTwoScore >= 10) {
        showWinningDialog('Team Two Wins!');
      }
    if (servingTeam == 1 && teamOneScore <=10 && teamTwoScore <=10) {
      teamOneScore++;
      
    } else if (servingTeam == 2 && teamOneScore <=10 && teamTwoScore <=10) {
      teamTwoScore++;
      
    }
  });
}
void showWinningDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Restart Game'),
            onPressed: () {
              resetGame();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  void resetGame() {
    setState(() {
      teamOneScore = 0;
      teamTwoScore = 0;
      currentServe = 2;
      servingTeam = 1;
      isFirstServer = true;
      // Clear any action history if you implemented undo functionality
    });
  }


  void switchServer() {
    setState(() {
      if (currentServe == 1) {
        // Switch to second server of the same team
        currentServe = 2;
      } else {
        // Switch serve to the other team and reset to first server
        servingTeam = servingTeam == 1 ? 2 : 1;
        currentServe = 1;
      }
      isFirstServer = !isFirstServer;
    });
  }

  void undoLastAction() {
    // Add your undo logic here
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Score Tracker'),
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
          // Navigate back to home screen or previous screen
        },
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Provide even spacing
      children: [
        Expanded(
          child: TeamScoreArea(score: teamOneScore, teamColor: Colors.green),
        ),
         ScoreDisplay(
          teamOneScore: teamOneScore,
          teamTwoScore: teamTwoScore,
          currentServe: currentServe,
          onIncrementScore: incrementScore, // Pass the increment score method
          onFault: switchServer, // Pass the fault handler method
        ),
        Expanded(
          child: TeamScoreArea(score: teamTwoScore, teamColor: Colors.blue),
        ),
        ControlButtons(
          onUndo: undoLastAction,
          onIncrementScore: incrementScore,
          onFault: switchServer,
        ),
      ],
    ),
    bottomNavigationBar: CustomBottomNavBar(
      selectedIndex: _selectedIndex,
      onItemSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    ),
  );
}
}

class TeamScoreArea extends StatelessWidget {
  final int score;
  final Color teamColor;

  const TeamScoreArea({
    Key? key,
    required this.score,
    required this.teamColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: teamColor.withAlpha(150), // Semi-transparent
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
      child: Stack(
        children: [
          Center(
            child: Container(
              height: double.infinity,
              width: 3, // Width of the line
              color: Colors.white54, // Color of the line
            ),
          ),
          
        ],
      ),
    );
  }
}

class ScoreDisplay extends StatefulWidget {
  final int teamOneScore;
  final int teamTwoScore;
  final int currentServe;
  final VoidCallback onIncrementScore;
  final VoidCallback onFault;

  const ScoreDisplay({
    Key? key,
    required this.teamOneScore,
    required this.teamTwoScore,
    required this.currentServe,
    required this.onIncrementScore,
    required this.onFault,
  }) : super(key: key);

  @override
  _ScoreDisplayState createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> with SingleTickerProviderStateMixin {
  double _dragExtent = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut))
      ..addListener(() {
        setState(() {
          _dragExtent = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta!;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.dx.abs();
    if (magnitude > 300.0) { // A threshold to determine if the swipe was intentional
      if (_dragExtent > 0) {
        widget.onIncrementScore();
      } else {
        widget.onFault();
      }
    }

    _animation = Tween<double>(begin: _dragExtent, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Transform.translate(
        offset: Offset(_dragExtent, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${widget.teamOneScore} - ${widget.teamTwoScore} | ${widget.currentServe}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}






class ControlButtons extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onIncrementScore;
  final VoidCallback onFault;

  const ControlButtons({
    Key? key,
    required this.onUndo,
    required this.onIncrementScore,
    required this.onFault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: onUndo,
            child: Icon(Icons.undo),
            backgroundColor: Colors.grey.shade400,
          ),
          FloatingActionButton(
            onPressed: onFault,
            child: Icon(Icons.remove),
            backgroundColor: Colors.pink.shade200,
          ),
          FloatingActionButton(
            onPressed: onIncrementScore,
            child: Icon(Icons.add),
            backgroundColor: Colors.green.shade400,
          ),
        ],
      ),
    );
  }
  
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.scoreboard),
          label: 'Scoring',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Check In',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: onItemSelected,
    );
  }
}


