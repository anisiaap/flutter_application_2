import 'package:flutter/material.dart';

class FavePageBackground extends StatelessWidget {
  final screenHeight;

  const FavePageBackground({Key? key, @required this.screenHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Stack(
      children: [
        Container(
          color:
              themeData.primaryColor, // Set background color to primary color
          height: screenHeight,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: BottomShapeClipper(),
            child: Container(
              height: screenHeight * 0.1,
              color: Colors.white, // Set curve color to white
            ),
          ),
        ),
      ],
    );
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height); // Move to the bottom-left corner

    // Create a wave-like shape using cubic bezier curves
    path.cubicTo(size.width / 6, size.height * 0.75,
        size.width / 3, size.height * 0.65,
        size.width / 2, size.height * 0.75); // First curve
    path.cubicTo(size.width * 2 / 3, size.height * 0.85,
        size.width * 5 / 6, size.height * 0.95,
        size.width, size.height * 0.75); // Second curve
    path.lineTo(size.width, 0); // Line to top-right corner
    path.lineTo(0, 0); // Line back to top-left corner
    path.close(); // Close the path
    return path;
  }



  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
