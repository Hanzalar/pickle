import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'performance_model.dart';

class PerformanceView extends StatefulWidget {
  @override
  _PerformanceViewState createState() => _PerformanceViewState();
}

class _PerformanceViewState extends State<PerformanceView> {
  IconData? _selectedIcon;
  final _outcomeController = TextEditingController();
  final _notesController = TextEditingController();

  void _selectIcon(IconData icon) {
    setState(() {
      _selectedIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerformanceModel>(
      builder: (context, performanceModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Performance'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text('Game Results:', style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: performanceModel.gameResults.length,
                    itemBuilder: (context, index) {
                      final result = performanceModel.gameResults[index];
                      return ListTile(
                        title: Text(result.outcome),
                        subtitle: Text(result.notes),
                        trailing: Icon(result.icon),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Add New Result:', style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _outcomeController,
                  decoration: InputDecoration(labelText: 'Outcome (Win/Loss)'),
                ),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Notes'),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    IconSelectionButton(icon: Icons.thumb_up,
                        onSelect: () => _selectIcon(Icons.thumb_up)),
                    IconSelectionButton(icon: Icons.thumb_down,
                        onSelect: () => _selectIcon(Icons.thumb_down)),
                    IconSelectionButton(icon: Icons.sentiment_satisfied,
                        onSelect: () => _selectIcon(Icons.sentiment_satisfied)),
                    IconSelectionButton(icon: Icons.sentiment_dissatisfied,
                        onSelect: () =>
                            _selectIcon(Icons.sentiment_dissatisfied)),
                    // Add more icons as needed
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final newResult = GameResult(
                        _outcomeController.text, _notesController.text,
                        _selectedIcon);
                    performanceModel.addGameResult(newResult);

                    // Clear text controllers and selected icon after adding a new result
                    _outcomeController.clear();
                    _notesController.clear();
                    _selectedIcon = null;
                  },
                  child: Text('Add Result'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
class IconSelectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onSelect;

  const IconSelectionButton({
    Key? key,
    required this.icon,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onSelect,
    );
  }
}
