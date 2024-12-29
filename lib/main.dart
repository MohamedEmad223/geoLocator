import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/feature/geolocator/logic/cubit/location_cubit.dart';
import 'package:map/feature/geolocator/views/screens/location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoLocator Demo',
      home: BlocProvider(
        create: (context) => LocationCubit(),
        child: LocationScreen(),
      ),
    );
  }
}
