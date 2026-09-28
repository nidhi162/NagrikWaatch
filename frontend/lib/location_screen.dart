import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;

  LatLng? currentLocation;
  bool loading = false;
  String locationText = 'Location not selected';

  Future<void> getCurrentLocation() async {
    setState(() {
      loading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          locationText = 'Please enable location/GPS on your device.';
          loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          locationText = 'Location permission denied.';
          loading = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationText = 'Location permission permanently denied. Please enable it from browser settings.';
          loading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final location = LatLng(position.latitude, position.longitude);

      setState(() {
        currentLocation = location;
        locationText =
            'Latitude: ${position.latitude}\n'
            'Longitude: ${position.longitude}';
        loading = false;
      });

      mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
    } catch (e) {
      setState(() {
        locationText = 'Unable to get location: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NagrikWatch Location'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: currentLocation == null
                ? const Center(
                    child: Text(
                      'Press "Use Current Location"\nto find your location.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation!,
                      zoom: 16,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('current-location'),
                        position: currentLocation!,
                        infoWindow: const InfoWindow(
                          title: 'Your Location',
                          snippet: 'NagrikWatch current location',
                        ),
                      ),
                    },
                  ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  locationText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : getCurrentLocation,
                    icon: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.location_on),
                    label: Text(
                      loading ? 'Getting Location...' : 'Use Current Location',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
