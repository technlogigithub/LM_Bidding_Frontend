import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../../core/app_config.dart';
import '../../widget/form_widgets/app_button.dart';


class GoogleMapPickerScreen extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const GoogleMapPickerScreen({
    Key? key,
    required this.initialLat,
    required this.initialLng,
  }) : super(key: key);

  @override
  State<GoogleMapPickerScreen> createState() => _GoogleMapPickerScreenState();
}

class _GoogleMapPickerScreenState extends State<GoogleMapPickerScreen> {
  LatLng? selectedLocation;
  String? selectedAddress;
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  bool isLoadingAddress = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    selectedLocation = LatLng(widget.initialLat, widget.initialLng);
    _getAddressFromLatLng(selectedLocation!);
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    setState(() => isLoadingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        selectedAddress =
        "${p.street ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}";
      } else {
        selectedAddress = "Unknown Location";
      }
    } catch (e) {
      selectedAddress = "Unknown Location";
      print("Error fetching address: $e");
    } finally {
      setState(() => isLoadingAddress = false);
    }
  }

  Future<List<Map<String, dynamic>>> _getPlaceSuggestions(String input) async {
    if (input.isEmpty) return [];
    final apiKey = AppInfo.googleAddressKey;
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&types=geocode&components=country:in';
    try {
      final response = await http.get(Uri.parse(url));
      print("Suggestions API response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Suggestions API response: ${data['status']}");
        if (data['status'] == 'OK') {
          return List<Map<String, dynamic>>.from(data['predictions']);
        } else {
          print("API error: ${data['status']}, ${data['error_message']}");
        }
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
    return [];
  }

  Future<void> _selectPlace(String placeId) async {
    final apiKey = AppInfo.googleAddressKey;
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      print("Place details API response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          final newLocation = LatLng(location['lat'], location['lng']);
          setState(() {
            selectedLocation = newLocation;
            _searchController.text = data['result']['formatted_address'];
          });
          await _getAddressFromLatLng(newLocation);
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: newLocation, zoom: 15),
            ),
          );
        } else {
          print("Place details API error: ${data['status']}, ${data['error_message']}");
        }
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error selecting place: $e");
    }
  }

  void _onMapTap(LatLng latLng) async {
    setState(() => selectedLocation = latLng);
    await _getAddressFromLatLng(latLng);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensure suggestions are not obscured by keyboard
      appBar: AppBar(backgroundColor: Colors.white,title: Text(" Search the Location "),),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(target: selectedLocation!, zoom: 15),
            onMapCreated: (controller) {
              if (mounted) mapController = controller;
            },
            onTap: _onMapTap,
            markers: selectedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('selected'),
                position: selectedLocation!,
              ),
            }
                : {},
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
          ),

          // Positioned search bar
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TypeAheadField<Map<String, dynamic>>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search location',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      // Debounce API calls to prevent excessive requests
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        _getPlaceSuggestions(value);
                      });
                    },
                  );
                },
                suggestionsCallback: _getPlaceSuggestions,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['description'] ?? 'Unknown'),
                  );
                },
                onSelected: (suggestion) {
                  _selectPlace(suggestion['place_id']);
                },
                emptyBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("No places found"),
                ),
                decorationBuilder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: child,
                  );
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: selectedAddress != null
          ? Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLoadingAddress ? 'Loading...' : selectedAddress!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(onTap:  () {
              if (selectedLocation != null && selectedAddress != null) {
                Navigator.pop(context, {
                  'latitude': selectedLocation!.latitude.toString(),
                  'longitude': selectedLocation!.longitude.toString(),
                  'address': selectedAddress!,
                });
              }
            },text:"Select" ,)
            // ButtonGlobalWithoutIcon(
            //   buttontext: "Select",
            //   buttonDecoration: BoxDecoration(
            //     color: const Color(0xFF69B22A),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   buttonTextColor: Colors.white,
            //   onPressed: () {
            //     if (selectedLocation != null && selectedAddress != null) {
            //       Navigator.pop(context, {
            //         'latitude': selectedLocation!.latitude.toString(),
            //         'longitude': selectedLocation!.longitude.toString(),
            //         'address': selectedAddress!,
            //       });
            //     }
            //   },
            // ),
          ],
        ),
      )
          : null,
    );
  }
}