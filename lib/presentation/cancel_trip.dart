import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'map/widgets/signalR_service.dart';

class CancellationNotificationPage extends StatefulWidget {
  const CancellationNotificationPage({super.key});

  @override
  _CancellationNotificationPageState createState() => _CancellationNotificationPageState();
}

class _CancellationNotificationPageState extends State<CancellationNotificationPage> {
  final SignalRService signalRService = SignalRService();
  Map<String, dynamic> notificationData = {};

  @override
  void initState() {
    super.initState();
    _listenForCancellationNotifications();
  }

  void _listenForCancellationNotifications() {
    signalRService.cancellationNotificationStream.listen((data) {
      setState(() {
        notificationData = data;
      });
    });
  }

  @override
  void dispose() {
    signalRService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Notification Test driver app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notificationData.isEmpty)
              const Text(
                "No notifications yet.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )
            else ...[
              const Text(
                "Cancellation Details:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailRow("Rider ID:", notificationData['RiderId'] ?? ''),
              _buildDetailRow("Driver ID:", notificationData['DriverId'] ?? ''),
              _buildDetailRow("Reason:", notificationData['Reason'] ?? ''),
              _buildDetailRow("Cancelling Party:", notificationData['CancellingParty'] ?? ''),
              const SizedBox(height: 16),
              Text(
                notificationData['CancellingParty'] == "Driver"
                    ? "Driver cancelled the trip."
                    : "Rider cancelled the trip.",
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}