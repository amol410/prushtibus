import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Bus_Status extends StatefulWidget {
  const Bus_Status({super.key});

  @override
  _Bus_StatusState createState() => _Bus_StatusState();
}

class _Bus_StatusState extends State<Bus_Status> {
  String selectedBus = "Shankeshwar (0459)";
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final LatLng _destinationLocation = const LatLng(21.068410, 73.134510);
  final Location _location = Location();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> polylineCoordinates = [];
  late PolylinePoints _polylinePoints;
  bool _isLoading = true;
  final int rows = 10;
  final int cols = 10;
  final List<List<bool>> seatStatus =
  List.generate(10, (row) => List.generate(4, (col) => row < 6));

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();
    _getLocationPermission();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _currentLocation = await _location.getLocation();
    setState(() {
      _isLoading = false; // Stop loading when location is available
    });

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Buses"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Buses"),
              Tab(text: "Seats"),
              Tab(text: "Routes"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBusList(),
            _buildExpanded(),
            _buildRouteMap(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusList() {
    List<String> buses = [
      "Shankeshwar (0459)",
      "Maa Travel (2270)",
      "Thakar (0811)",
      "Sai Nath (9929)"
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: buses.map((bus) {
        return ExpansionTile(
          title: Text(bus),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Bus details go here..."),
            ),
          ],
        );
      }).toList(),
    );
  }

  // SeatMap
  Expanded _buildExpanded() {
    return Expanded(
      child: Column(children: [
        // Door Label
        _buildAlign(),

        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: DropdownButton<String>(
            value: selectedBus,
            onChanged: (value) {
              setState(() {
                selectedBus = value!;
              });
            },
            items: [
              "Shankeshwar (0459)",
              "Maa Travel (2270)",
              "Thakar (0811)",
              "Sai Nath (9929)"
            ]
                .map((bus) => DropdownMenuItem(value: bus, child: Text(bus)))
                .toList(),
          ),
        ),

        const Image(
          image: AssetImage("assets/images/hendle.png"),
          // Set width
          height: 70, // Set height
          fit: BoxFit.cover, // Optional: Adjust how the image fits
        ),
        const Text("Driver"),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(Colors.red, "Filled"),
            const SizedBox(width: 20),
            _buildLegend(Colors.grey, "Available"),
          ],
        ),
        const SizedBox(height: 20), // Increased spacing

        // Seat Layout with Driver Icon
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Key change for even spacing
            children: [
              // Left Column Seats
              Expanded(
                  flex: 2, // Added flex for better distribution
                  child: _buildSeatColumn(0, 2)), // Indices for left seats

              // Driver Icon (Centered)

              // Right Column Seats
              Expanded(
                flex: 2, // Added flex for better distribution
                child: _buildSeatColumn(1, 4), // Indices for right seats
              ),
            ],
          ),
        ),

        const SizedBox(height: 20), // Increased spacing

        // Legend
      ]),
    );
  }

  Widget _buildAlign() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text("Door"),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Icon(Icons.event_seat, color: color, size: 25),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildSeatColumn(int startCol, int endCol) {
    // Added indices
    return SingleChildScrollView(
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(endCol - startCol, (colIndex) {
              // Use indices
              bool isFilled =
              seatStatus[rowIndex][startCol + colIndex]; // Use indices
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.event_seat,
                  size: 45,
                  color: isFilled ? Colors.red : Colors.grey,
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildRouteMap() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            value: selectedBus,
            onChanged: (value) {
              setState(() {
                selectedBus = value!;
              });
            },
            items: [
              "Shankeshwar (0459)",
              "Maa Travel (2270)",
              "Thakar (0811)",
              "Sai Nath (9929)"
            ]
                .map((bus) => DropdownMenuItem(value: bus, child: Text(bus)))
                .toList(),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading until location is fetched
              : GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                  zoom: 15,
                ),
              ));
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentLocation!.latitude!,
                _currentLocation!.longitude!,
              ),
              zoom: 14,
            ),
            markers: _markers
              ..add(Marker(
                markerId: const MarkerId('current_location'),
                position: LatLng(
                  _destinationLocation.latitude,
                  _destinationLocation.longitude,
                ),
                infoWindow: const InfoWindow(title: 'You are here'),
              )),
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true, // Enables pinch zooming
            scrollGesturesEnabled: true, // Enables panning with two fingers
            tiltGesturesEnabled: true, // Enables tilting the camera angle
            rotateGesturesEnabled: true, // Enables rotating the map
            gestureRecognizers: <dynamic>{}
              ..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())), // Ensures smooth two-finger gestures
          ),
        ),
      ],
    );
  }
}
