import 'package:flutter/material.dart';

class AddIndicatorWidget extends StatefulWidget {
  final List<String> indicatorsList;
  final Function(String, int) onAddIndicator;

  const AddIndicatorWidget({
    required this.indicatorsList,
    required this.onAddIndicator,
    super.key,
  });

  @override
  _AddIndicatorWidgetState createState() => _AddIndicatorWidgetState();
}

class _AddIndicatorWidgetState extends State<AddIndicatorWidget> {
  final TextEditingController _periodController = TextEditingController();

  String? _selectedIndicator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(top: 28),
            child: DropdownButton<String>(
              items: widget.indicatorsList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIndicator = newValue;
                });
              },
              hint: Text('Indicator'),
              value: _selectedIndicator,
            ),
          ),
        ),
        Flexible(
          child: TextField(
            controller: _periodController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Period'),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(top: 28),
            child: IconButton(
              onPressed: () {
                if (_selectedIndicator != null && _periodController.text.isNotEmpty) {
                  widget.onAddIndicator(_selectedIndicator!, int.parse(_periodController.text));
                }
              },
              icon: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
