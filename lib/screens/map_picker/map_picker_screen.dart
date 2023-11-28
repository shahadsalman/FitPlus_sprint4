import 'dart:async';
import 'dart:math';

import 'package:fitplus/services/location_service.dart';
import 'package:fitplus/value/constant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/search_place_textfield.dart';
import 'models/lat_lng_model.dart' as lat_lng;
import 'models/place_info.dart';
import 'models/place_suggestion.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({this.lat, this.lng, this.circles, this.markers, this.polygons, this.countries = const [], Key? key}) : super(key: key);
  final double? lat, lng;
  final Set<Marker>? markers;
  final Set<Circle>? circles;
  final Set<Polygon>? polygons;
  final List<String> countries;

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late CameraPosition _initialLocation;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final double _defaultZoom = 16; //14.4746;
  String? _locErr;
  lat_lng.LatLng? _currentPosition;
  PlaceInfo? _placeInfo;

  bool _isLoading = false;
  bool _isPosLoading = false;
  Timer? _deBouncer;

  @override
  void initState() {
    super.initState();
    if (widget.lat != null && widget.lng != null) {
      _initialLocation = CameraPosition(target: LatLng(widget.lat!, widget.lng!), zoom: _defaultZoom);
    } else {
      _initialLocation = CameraPosition(target: const LatLng(24.7136, 46.6753), zoom: _defaultZoom);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setInitialLocation();
    });
  }

  Widget _pinWidget() {
    return const Icon(
      Icons.location_on_rounded,
      size: 60,
    );
  }

  Widget _textFieldWidget() {
    return Positioned(
      top: Get.mediaQuery.viewPadding.top - 10,
      child: Row(
        children: [
          SizedBox(
            width: min(Get.width, 340),
            child: SearchPlaceTextField(
              countries: widget.countries,
              onSuggestionTapped: _moveCameraToSuggestionLocation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressSheet() {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        _placeInfo?.address ?? "",
                        style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
                      ),
                    ),
                  ],
                ),
                if (_locErr != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      _locErr!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xffF56E66), fontSize: 10, fontWeight: FontWeight.w500, height: 1.5),
                    ),
                  ),
                const SizedBox(height: 15),
                TextButton(
                    onPressed: () {
                      Get.back(result: _placeInfo);
                    },
                    child: const Text("Confirm Location")),
                const SizedBox(height: 10),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Choose Gym Location"),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: SizedBox(
          width: Get.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                buildingsEnabled: false,
                markers: widget.markers ?? {},
                circles: widget.circles ?? {},
                polygons: widget.polygons ?? {},
                initialCameraPosition: _initialLocation,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMove: (CameraPosition position) {
                  if (_locErr != null) {
                    _locErr = null;
                    setState(() {});
                  }
                  _updatePosition(position.target);
                },
                onCameraIdle: () async {},
                onCameraMoveStarted: () {},
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _addressSheet(),
                  ],
                ),
              ),
              _textFieldWidget(),
              _pinWidget(),
              if (_isPosLoading) Container(color: Colors.white, child: const Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updatePosition(LatLng pos) async {
    _currentPosition = lat_lng.LatLng(latitude: pos.latitude, longitude: pos.longitude);
    if (_deBouncer?.isActive ?? false) {
      _deBouncer?.cancel();
    }

    _deBouncer = Timer(const Duration(milliseconds: 500), () async {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      try {
        _placeInfo = await LocationService.I.getPlaceInfoFromLatLng(_currentPosition!);
        _locErr = null;
      } catch (e) {
        print(e);
        _locErr = "unable to find location";
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _moveCameraToSuggestionLocation(PlaceSuggestion suggestion) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final pos = await LocationService.I.getLatLngFromPlaceId(suggestion.id);
      if (pos != null) {
        _moveToCameraPosition(CameraPosition(target: LatLng(pos.latitude ?? 0, pos.longitude ?? 0), zoom: _defaultZoom));
      } else {
        _locErr = "unable to find location";
      }
    } catch (_) {
      _locErr = "unable to find location";
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _moveToCameraPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<void> _moveToUserPosition() async {
    try {
      final Position? locData = await LocationService.I.getLocationData();
      if (locData != null) {
        _moveToCameraPosition(CameraPosition(target: LatLng(locData.latitude, locData.longitude), zoom: _defaultZoom));
      }
    } catch (_) {}
  }

  Future<void> _setInitialLocation() async {
    if (mounted) {
      setState(() {
        _isPosLoading = true;
      });
    }
    try {
      _updatePosition(_initialLocation.target);
    } catch (e) {
      _locErr = "unable to find location";
    }
    if (mounted) {
      setState(() {
        _isPosLoading = false;
      });
    }
  }
}
