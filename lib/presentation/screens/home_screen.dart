import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/trip_provider.dart';
import 'my_trips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _generateTrip(String prompt) {
    if (prompt.isEmpty) return;
    Provider.of<TripProvider>(context, listen: false).createTrip(prompt, _selectedDate).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyTripsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Trip Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyTripsScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Where do you want to go?', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. Plan a 3-day romantic weekend in Paris focusing on art and food.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _generateTrip(_promptController.text),
                    child: const Text('Generate'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text('Suggested Templates', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            ...AppConstants.preBakedTemplates.map((template) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(template['title']),
                  subtitle: Text(template['prompt']),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _promptController.text = template['prompt'];
                    _generateTrip(template['prompt']);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
