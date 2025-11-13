import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/app_config.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import 'app_button.dart';
import 'app_textfield.dart';

class ReusableLocationPickerScreen extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(LatLng, String, String) onLocationSelected;
  final String? title;

  const ReusableLocationPickerScreen({
    Key? key,
    required this.initialLat,
    required this.initialLng,
    required this.onLocationSelected,
    this.title,
  }) : super(key: key);

  @override
  State<ReusableLocationPickerScreen> createState() => _ReusableLocationPickerScreenState();
}

class _ReusableLocationPickerScreenState extends State<ReusableLocationPickerScreen> {
  LatLng? selectedLocation;
  String? selectedAddress;
  String _currentLandmark = '';
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
        
        // Extract landmark information
        String landmark = '';
        if (p.subLocality?.isNotEmpty == true) {
          landmark = p.subLocality!;
        } else if (p.locality?.isNotEmpty == true) {
          landmark = p.locality!;
        } else if (p.administrativeArea?.isNotEmpty == true) {
          landmark = p.administrativeArea!;
        }
        
        // Store landmark for later use
        _currentLandmark = landmark;
      } else {
        selectedAddress = "Unknown Location";
        _currentLandmark = '';
      }
    } catch (e) {
      selectedAddress = "Unknown Location";
      _currentLandmark = '';
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
          final formattedAddress = data['result']['formatted_address'];
          
          // Extract landmark from Google Places API response
          String landmark = '';
          final addressComponents = data['result']['address_components'] as List;
          for (var component in addressComponents) {
            final types = component['types'] as List;
            if (types.contains('sublocality') || types.contains('sublocality_level_1')) {
              landmark = component['long_name'];
              break;
            } else if (types.contains('locality')) {
              landmark = component['long_name'];
            }
          }
          
          setState(() {
            selectedLocation = newLocation;
            _searchController.text = formattedAddress;
            _currentLandmark = landmark;
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

  void _selectLocation() {
    if (selectedLocation != null && selectedAddress != null) {
      widget.onLocationSelected(selectedLocation!, selectedAddress!, _currentLandmark);
      Get.back();
    }
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        backgroundColor: AppColors.appColor,
        title: Text(
          widget.title ?? AppStrings.selectLocation,
          style: AppTextStyle.kTextStyle.copyWith(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Material(
              elevation: 4,
              color: whiteColor,
              borderRadius: BorderRadius.circular(8),
              child: TypeAheadField<Map<String, dynamic>>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return CustomTextfield(
                    label: AppStrings.searchLocation,
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (value) {
                      // Debounce API calls to prevent excessive requests
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        _getPlaceSuggestions(value);
                      });
                    },
                    hintText: AppStrings.searchLocation,
                  );
                },
                suggestionsCallback: _getPlaceSuggestions,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['description'] ?? AppStrings.unknown, 
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.appTextColor,
                      ),
                    ),
                  );
                },
                onSelected: (suggestion) {
                  _selectPlace(suggestion['place_id']);
                },
                emptyBuilder: (context) => Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    AppStrings.noPlacesFound,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
              isLoadingAddress ? AppStrings.loading : selectedAddress!,
              style: AppTextStyle.kTextStyle.copyWith(
                color: AppColors.appTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onTap: _selectLocation,
              text: AppStrings.select,
            ),
          ],
        ),
      )
          : null,
    );
  }
}
