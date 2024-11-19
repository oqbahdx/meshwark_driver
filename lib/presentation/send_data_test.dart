import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwark_driver/presentation/map/widgets/signalR_service.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final SignalRService _signalRService = SignalRService();
  Map<String, dynamic>? _rideRequest;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    // Listen to the ride request stream
    _signalRService.rideRequestStream.listen((rideRequest) {
      setState(() {
        _rideRequest = rideRequest;
      });
      // Show the bottom sheet when a ride request is received
      _showRideRequestBottomSheet(rideRequest);
    });
  }

  @override
  void dispose() {
    _signalRService.dispose();
    super.dispose();
  }

  void _showRideRequestBottomSheet(Map<String, dynamic> rideRequest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        LatLng riderLocation = LatLng(
          rideRequest['request']['latitude'],
          rideRequest['request']['longitude'],
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "New Ride Request",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Rider: ${rideRequest['request']['firstName']} ${rideRequest['request']['lastName']}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Price: \$${rideRequest['request']['price']}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Passengers: ${rideRequest['request']['passengers']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "Passengers: ${rideRequest['request']['passengers']}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Rider ID: ${rideRequest['riderId'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Google Map displaying the rider's location
              SizedBox(
                height: 200,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: riderLocation,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('riderLocation'),
                      position: riderLocation,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _signalRService.hubConnection.invoke(
                        'SendDriverResponse',
                        args: [rideRequest['riderId'], true],
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text("Accept"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _signalRService.hubConnection.invoke(
                        'SendDriverResponse',
                        args: [rideRequest['riderId'], false],
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text("Reject"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
      ),
      body: Center(
        child: _rideRequest == null
            ? const Text('Waiting for ride requests...')
            : const Text(
                'Ride request received! Check bottom sheet for details.'),
      ),
    );
  }
}
