import 'dart:math';
import 'package:signalr_netcore/signalr_client.dart' as signalr;
import 'package:logging/logging.dart';
import 'dart:async';
import 'dart:convert';

import '../../../app/constant.dart';

class SignalRService {
  late final signalr.HubConnection hubConnection;
  final driverResponseController = StreamController<bool>.broadcast();
  Stream<bool> get driverResponseStream => driverResponseController.stream;
  final rideRequestController = StreamController<Map<String, dynamic>>.broadcast();
  final connectionStatusController = StreamController<String>.broadcast();
  final driverUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final cancellationNotificationController = StreamController<Map<String, dynamic>>.broadcast(); // New controller for cancellation notifications
  final Logger logger = Logger('SignalRService');

  SignalRService() {
    initializeConnection();
  }

  Future<void> initializeConnection() async {
    hubConnection = signalr.HubConnectionBuilder()
        .withUrl('${Constants.hubUrl}driverHub')
        .build();

    hubConnection.on('ReceiveRideRequest', _handleRideRequest);
    hubConnection.on('ReceiveDriverUpdate', _handleDriverUpdate);
    hubConnection.onclose(_onConnectionClosed);

    // Add the event listener for receiving the driver response
    hubConnection.on('ReceiveDriverResponse', (List<dynamic>? args) {
      print("ReceiveDriverResponse event fired: $args");
      if (args != null && args.isNotEmpty) {
        if (!driverResponseController.isClosed) {
          driverResponseController.add(args[0] as bool);
        }
      }
    });

    // Add the event listener for receiving cancellation notifications
    hubConnection.on('ReceiveCancellationNotification', _handleCancellationNotification);

    try {
      await hubConnection.start();
      logger.info("Connected to SignalR hub");
      print("SignalR connection started successfully");
      await _identifyDriver();
      connectionStatusController.add("Connected. Waiting for updates...");
    } catch (e) {
      logger.severe("Error connecting to SignalR hub: $e");
      print("Error connecting to SignalR: $e");
      connectionStatusController.add("Connection failed. Retrying...");
      await _reconnectWithBackoff();
    }
  }

  Future<void> _identifyDriver() async {
    try {
      final result = await hubConnection.invoke('IdentifyDriver', args: <Object>[Constants.id]);

      if (result != null) {
        logger.info("Driver identified successfully: $result");
        print("Driver identified successfully: $result");
      } else {
        logger.warning("Driver identification returned null.");
        print("Driver identification returned null.");
      }
    } catch (e) {
      logger.severe("Error identifying driver: $e");
      print("Error identifying driver: $e");
    }
  }


  Future<void> _reconnectWithBackoff() async {
    int retryCount = 0;
    const int maxRetries = 5;
    const Duration initialDelay = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        await hubConnection.start();
        logger.info("Reconnected to SignalR hub");
        connectionStatusController.add("Connected. Waiting for updates...");
        return;
      } catch (e) {
        logger.warning("Error reconnecting to SignalR hub: $e");
        retryCount++;
        final Duration delay = initialDelay * pow(2, retryCount);
        connectionStatusController.add("Connection failed. Retrying in ${delay.inSeconds} seconds...");
        await Future.delayed(delay);
      }
    }
    logger.severe("Maximum number of reconnection attempts reached.");
    connectionStatusController.add("Failed to connect. Please try again later.");
  }

  void _onConnectionClosed({Exception? error}) {
    logger.warning("Connection closed. Attempting to reconnect...");
    connectionStatusController.add("Connection closed. Reconnecting...");
    _reconnectWithBackoff();
  }

  void _handleRideRequest(List<dynamic>? args) {
    logger.info("Ride request received: $args");
    if (args != null && args.isNotEmpty && args[0] is Map<String, dynamic>) {
      final data = args[0] as Map<String, dynamic>;
      logger.info("Received data structure: $data");
      final rideRequest = {
        'riderId': data['riderId'],
        'request': data['request'],
      };
      logger.info("Processed ride request: $rideRequest");
      rideRequestController.sink.add(rideRequest);
    } else {
      logger.warning("Received invalid ride request data: $args");
    }
  }

  void _handleDriverUpdate(List<dynamic>? args) {
    logger.info("Driver update received: $args");
    if (args != null && args.isNotEmpty && args[0] is Map<String, dynamic>) {
      final data = args[0] as Map<String, dynamic>;
      logger.info("Received driver update: $data");
      driverUpdateController.sink.add(data);
    } else {
      logger.warning("Received invalid driver update data: $args");
    }
  }

  void _handleCancellationNotification(List<dynamic>? args) {
    logger.info("Cancellation notification received: $args");
    if (args != null && args.isNotEmpty) {
      Map<String, dynamic> data;
      if (args[0] is String) {
        // If the data is serialized as a JSON string
        data = json.decode(args[0] as String);
      } else if (args[0] is Map<String, dynamic>) {
        // If the data is already a Map
        data = args[0] as Map<String, dynamic>;
      } else {
        logger.warning("Received invalid cancellation notification data: $args");
        return;
      }

      logger.info("Processed cancellation notification: $data");
      cancellationNotificationController.sink.add(data);
    } else {
      logger.warning("Received invalid cancellation notification data: $args");
    }
  }

  Stream<Map<String, dynamic>> get rideRequestStream => rideRequestController.stream;
  Stream<String> get connectionStatus => connectionStatusController.stream;
  Stream<Map<String, dynamic>> get driverUpdateStream => driverUpdateController.stream;
  Stream<Map<String, dynamic>> get cancellationNotificationStream => cancellationNotificationController.stream; // New stream for cancellation notifications

  void dispose() {
    driverUpdateController.close();
    rideRequestController.close();
    driverResponseController.close();
    cancellationNotificationController.close(); // Close the new stream
    hubConnection.stop();
  }
}
