import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/feature/geolocator/logic/cubit/location_cubit.dart';

class LocationScreen extends StatelessWidget {
  final TextEditingController _mapLinkController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location and Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  String message = "Address will appear here.";
                  if (state is LocationLoading) {
                    message = "Loading...";
                  } else if (state is LocationSuccess) {
                    message = state.address;
                  } else if (state is LocationFailure) {
                    message = state.message;
                  }
                  return Text(message, style: const TextStyle(fontSize: 16));
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _mapLinkController,
                decoration: const InputDecoration(
                  labelText: "Google Maps Link",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<LocationCubit>()
                      .getLocationFromGoogleMapsLink(_mapLinkController.text);
                },
                child: const Text("Get Location from Google Maps Link"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                  labelText: "Latitude",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                  labelText: "Longitude",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final latitude =
                      double.tryParse(_latitudeController.text) ?? 0.0;
                  final longitude =
                      double.tryParse(_longitudeController.text) ?? 0.0;
                  context.read<LocationCubit>().getLocationFromCoordinates(
                      latitude, longitude);
                },
                child: const Text("Get Location from Coordinates"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<LocationCubit>().getCurrentLocation();
                },
                child: const Text("Get Current Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
