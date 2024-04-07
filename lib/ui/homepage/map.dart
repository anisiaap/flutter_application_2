import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_2/model/event.dart';

class MapSample extends StatefulWidget {
  final Event event;

  const MapSample({Key? key, required this.event}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String get text => "lol";

  bool _showPopup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          content(),
          if (_showPopup) _buildPopup(),
        ],
      ),
    );
  }

  Widget content() {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
        border: Border.all(
          color: Colors.white, // Border color
          width: 50.0, // Border width
        ),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(45.7550128, 21.2285156),
            initialZoom: 11,
            interactionOptions:
                const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
          ), // MapOptions
          children: [
            openStreetMapTileLayer,
            MarkerLayer(markers: [
              Marker(
                point: LatLng(45.7550128, 21.2285156),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => setState(() => _showPopup = true),
                  child: Icon(
                    Icons.location_pin,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              ),
            ]),
          ],
        ), // FlutterMap
      ),
    );
  }

  Widget _buildPopup() {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() => _showPopup = false), // Dismiss on tap
        child: Container(
          width: 200,
          height: 100, // Adjust size as required
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8), // Semi-transparent black
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              widget.event.location,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
