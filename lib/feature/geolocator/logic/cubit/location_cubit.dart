
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  // Location from Google Maps link


Future<void> getLocationFromGoogleMapsLink(String url) async {
  emit(LocationLoading());

  try {
    // Step 1: Fetch the full redirection URL
    final response = await http.head(Uri.parse(url), headers: {'User-Agent': 'Flutter'});
    final resolvedUrl = response.headers['location'];

    // Debug resolved URL
    if (resolvedUrl == null || !resolvedUrl.contains('@')) {
      emit(LocationFailure("Invalid Google Maps link. Unable to extract coordinates."));
      return;
    }

    // Step 2: Extract coordinates from the resolved URL
    final regex = RegExp(r'@([-+]?[0-9]*\.?[0-9]+),([-+]?[0-9]*\.?[0-9]+)');
    final match = regex.firstMatch(resolvedUrl);

    if (match == null) {
      emit(LocationFailure("Invalid Google Maps link. Unable to extract coordinates."));
      return;
    }

    final latitude = double.parse(match.group(1)!);
    final longitude = double.parse(match.group(2)!);

    // Step 3: Validate coordinates
    if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
      emit(LocationFailure("Extracted coordinates are out of range."));
      return;
    }

    // Step 4: Use _resolveAddress to fetch the country name
    await _resolveAddress(latitude, longitude);
  } catch (e) {
    emit(LocationFailure("Failed to fetch location: ${e.toString()}"));
  }
}


  // Location from coordinates
 Future<void> getLocationFromCoordinates(double latitude, double longitude) async {
  emit(LocationLoading());
  try {
    // Validate latitude and longitude
    if (latitude < -90 || latitude > 90) {
      emit(LocationFailure("Invalid latitude. Must be between -90 and 90."));
      return;
    }
    if (longitude < -180 || longitude > 180) {
      emit(LocationFailure("Invalid longitude. Must be between -180 and 180."));
      return;
    }

    _resolveAddress(latitude, longitude);
  } catch (e) {
    emit(LocationFailure("Invalid coordinates."));
  }
}
  
    // Current location

 Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _resolveAddress(position.latitude, position.longitude);
    } catch (e) {
      emit(LocationFailure("Error fetching current location: ${e.toString()}"));
    }
  }



   Future<void> _resolveAddress(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = "${placemark.name}, ${placemark.locality}, ${placemark.country}";
        emit(LocationSuccess(address));
      } else {
        emit(LocationFailure("No address found for these coordinates."));
      }
    } catch (e) {
      emit(LocationFailure("Error resolving address: ${e.toString()}"));
    }
  }
  
}
