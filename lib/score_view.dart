import 'package:flutter/material.dart';
import 'score_model.dart'; // Include the path as per your directory structure 
import 'package:provider/provider.dart';

class ScoreView extends StatefulWidget {
  @override
  _ScoreViewState createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  int _selectedIndex = 0;
  ScoreModel? _scoreModel;


 @override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (Provider.of<ScoreModel>(context).isGameOver) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWinningDialog(Provider.of<ScoreModel>(context, listen: false).winningTeam);
    });
  }
}

void _showWinningDialog(String message) {
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
                    Navigator.of(context).pop();
                    Provider.of<ScoreModel>(context, listen: false).resetGame();
                    },
               ),
           ],
        );
     },
   );
}

 @override
Widget build(BuildContext context) {
  return Consumer<ScoreModel>(
  builder: (context, provider, child) {
    
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
          child: TeamScoreArea(score: Provider.of<ScoreModel>(context).teamOneScore, teamColor: Colors.green),
        ),
         ScoreDisplay(
          teamOneScore: Provider.of<ScoreModel>(context).teamOneScore,
          teamTwoScore: Provider.of<ScoreModel>(context).teamTwoScore,
          currentServe: Provider.of<ScoreModel>(context).currentServe,
          onIncrementScore: Provider.of<ScoreModel>(context).incrementScore,
          onFault: Provider.of<ScoreModel>(context).switchServer,
        ),
        Expanded(
          child: TeamScoreArea(score: Provider.of<ScoreModel>(context).teamTwoScore, teamColor: Colors.blue),
        ),
        ControlButtons(
          onUndo: Provider.of<ScoreModel>(context).undoLastAction,
          onIncrementScore: Provider.of<ScoreModel>(context).incrementScore,
          onFault: Provider.of<ScoreModel>(context).switchServer,
        ),
      ],
    ),
  );
  },
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