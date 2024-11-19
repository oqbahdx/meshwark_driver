import 'package:flutter/material.dart';
import 'package:meshwark_driver/presentation/map/widgets/signalR_service.dart';


import 'app/constant.dart'; // Import your SignalR service

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final SignalRService _signalRService = SignalRService(); // Instance of SignalR service

  @override
  void initState() {
    super.initState();

    // Listen for cancellation notifications
    _signalRService.cancellationNotificationStream.listen((data) {
      bool isDriver = data['IsDriver'];
      String reason = data['Reason'];
      String userType = isDriver ? 'Driver' : 'Rider';

      _showCancellationNotification(context, userType, reason);
    });
  }

  // Show cancellation notification
  void _showCancellationNotification(BuildContext context, String userType, String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Trip Cancelled'),
        content: Text('$userType has cancelled the trip. Reason: $reason'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Cancel trip and notify both rider and driver
  void _cancelTrip(bool isDriver) async {
    final reason = await _showCancelDialog();
    if (reason != null && reason.isNotEmpty) {
      // Notify the other party
      if (isDriver) {
        // If the driver is cancelling, notify the rider
        _signalRService.hubConnection.invoke('NotifyCancellation', args: ["fe6c7de9-b6a7-49d8-8c29-a2df626b77b9", reason, true]);
      } else {
        // If the rider is cancelling, notify the driver
        _signalRService.hubConnection.invoke('NotifyCancellation', args: ["9c4e684c-3d35-4afc-9b55-0cd04c35922f", reason, false]);
      }
    }
  }

  // Show dialog to get reason for cancellation
  Future<String?> _showCancelDialog() {
    TextEditingController _reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Trip'),
        content: TextField(
          controller: _reasonController,
          decoration: InputDecoration(hintText: 'Enter reason for cancellation'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_reasonController.text),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trip Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Trip Details Here'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Check if the current user is a driver or a rider
                bool isDriver = true; // Replace with logic to check if current user is a driver
                _cancelTrip(isDriver); // Call the cancel trip method
              },
              child: Text('Cancel Trip'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signalRService.dispose();
    super.dispose();
  }
}
