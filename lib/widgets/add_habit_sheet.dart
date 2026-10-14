import 'package:flutter/material.dart';

class AddHabitSheet extends StatefulWidget {
  final Function(String title, String description, IconData icon) onAddHabit;

  const AddHabitSheet({super.key, required this.onAddHabit});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  IconData _selectedIcon = Icons.bolt;

  final List<IconData> _availableIcons = [
    Icons.bolt,
    Icons.favorite,
    Icons.spa,
    Icons.psychology,
    Icons.menu_book,
    Icons.directions_run,
    Icons.nightlight_round,
    Icons.code,
    Icons.brush,
    Icons.music_note,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: BoxDecoration(
        color: const Color(0xFF101223).withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Launch New Habit Planet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Habit Name',
              labelStyle: const TextStyle(color: Colors.white60),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00E5FF)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Description / Goal',
              labelStyle: const TextStyle(color: Colors.white60),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00E5FF)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose Celestial Icon',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF00E5FF) : Colors.white10,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white24,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.black87 : Colors.white70,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty) {
                  widget.onAddHabit(
                    _titleController.text.trim(),
                    _descController.text.trim().isEmpty
                        ? 'Celestial orbit habit'
                        : _descController.text.trim(),
                    _selectedIcon,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Orbit Into Galaxy',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
