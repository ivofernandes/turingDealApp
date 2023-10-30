import 'dart:async';

import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';

class MarketTimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Time'.t),
      ),
      body: MarketTimeWidget(),
    );
  }
}

class MarketTimeWidget extends StatefulWidget {
  @override
  _MarketTimeWidgetState createState() => _MarketTimeWidgetState();
}

class _MarketTimeWidgetState extends State<MarketTimeWidget> {
  late DateTime now;
  late String currentTime;
  late String timeToOpen;
  late String timeToClose;

  late DateTime localOpenTime;

  late DateTime localCloseTime;

  final DateFormat localTimeFormat = DateFormat('hh:mm a');

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update time every second
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      now = DateTime.now().toUtc().subtract(const Duration(hours: 4)); // Convert to EST
      currentTime = DateFormat('hh:mm:ss a').format(now);

      DateTime openTime = DateTime(now.year, now.month, now.day, 9, 30);
      DateTime closeTime = DateTime(now.year, now.month, now.day, 16, 0);

      localOpenTime = openTime.add(const Duration(hours: 4)).toLocal();
      localCloseTime = closeTime.add(const Duration(hours: 4)).toLocal();
      final localTimeFormat = DateFormat('hh:mm a');

      if (now.isBefore(openTime)) {
        timeToOpen = _formatDuration(openTime.difference(now));

        timeToClose = 'Market is closed';
      } else if (now.isAfter(closeTime)) {
        timeToOpen = 'Market is closed';
        timeToClose = 'Market is closed';
      } else {
        timeToOpen = 'Market is open';
        timeToClose = _formatDuration(closeTime.difference(now));
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  Center(child: Text('')),
                  Center(child: Text('NY Time')),
                  Center(child: Text('Local Time')),
                ],
              ),
              TableRow(
                children: [
                  Center(child: Text('Open')),
                  Center(child: Text('09:30 AM')),
                  Center(child: Text(localTimeFormat.format(localOpenTime))),
                ],
              ),
              TableRow(
                children: [
                  Center(child: Text('Close')),
                  Center(child: Text('04:00 PM')),
                  Center(child: Text(localTimeFormat.format(localCloseTime))),
                ],
              ),
              TableRow(
                children: [
                  Center(child: Text('Now')),
                  Center(child: Text(currentTime)),
                  Center(child: Text(DateFormat('hh:mm:ss a').format(DateTime.now()))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Time to open: $timeToOpen',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Time to close: $timeToClose',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
