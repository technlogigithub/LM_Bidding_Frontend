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
import '../../controller/home/home_controller.dart';
import '../../core/app_config.dart';
import '../../core/app_textstyle.dart';
import 'app_button.dart';
import 'app_textfield.dart';

class LocationPickerScreen extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(LatLng, String)? onLocationSelected;

  const LocationPickerScreen({
    Key? key,
    required this.initialLat,
    required this.initialLng,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLocation;
  String? selectedAddress;
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  bool isLoadingAddress = false;
  Timer? _debounce;
  @override
  final String _darkMapStyle = '''[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]''';

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
            selectedAddress = data['result']['formatted_address'];
          });
          
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        backgroundColor: AppColors.appColor,
          title:  Text(
        AppStrings.selectLocation,
        style: AppTextStyle.title(
          color: AppColors.appTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      ),
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor, // <-- Apply your gradient here
          ),
          child: Stack(
            children: [
              // Google Map
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: selectedLocation!,
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  if (mounted) mapController = controller;
                  if (Get.isDarkMode) {
                    controller.setMapStyle(_darkMapStyle);
                  }
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

              // Search TextField
              Positioned(
                top: 10,
                left: 15,
                right: 15,
                child: Material(
                  elevation: 4,

                  borderRadius: BorderRadius.circular(8),
                  child:TypeAheadField<Map<String, dynamic>>(
                    controller: _searchController,

                    builder: (context, controller, focusNode) {
                      return CustomTextfield(
                        label: AppStrings.searchLocation,
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (value) {
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
                        title: Text(
                          suggestion['description'] ?? AppStrings.unknown,
                          style: AppTextStyle.description(
                            color: AppColors.appDescriptionColor,
                          ),
                        ),
                      );
                    },

                    onSelected: (suggestion) {
                      _selectPlace(suggestion['place_id']);
                    },

                    emptyBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        AppStrings.noPlacesFound,
                        style: AppTextStyle.description(
                          color: AppColors.appTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // ⬇️ CUSTOM LOADING INDICATOR
                    loadingBuilder: (context) {
                      return  Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(
                          child: CircularProgressIndicator(
                            color:AppColors.appColor,  // 🔥 YOUR COLOR
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },

                    // ⬇️ CUSTOM DROPDOWN CONTAINER
                    decorationBuilder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.appPagecolor, // 🔥 Set container bg color
                          borderRadius: BorderRadius.circular(10),
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
                  )
                  ,
                ),
              ),
            ],
          ),
        ),


        bottomNavigationBar: selectedAddress != null
          ? Container(
        padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
  gradient: AppColors.appPagecolor
),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLoadingAddress ? AppStrings.loading : selectedAddress!,
              style: AppTextStyle.title(
                color: AppColors.appBodyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onTap: (){
                if (widget.onLocationSelected != null) {
                  widget.onLocationSelected!(selectedLocation!, selectedAddress ?? '');
                  Get.back();
                  return;
                }
                Get.find<ClientHomeController>().updateLocation(
                  selectedLocation!,
                  selectedAddress ?? '',
                );
                Get.back();
              }, 
              text: AppStrings.select,
            ),
          ],
        ),
      )
          : null,
    );
  }
}