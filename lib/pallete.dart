import 'package:flutter/material.dart';

class GradientPalette {
  final List<Color> colors;

  GradientPalette(this.colors);

  LinearGradient getLinearGradient(double angleInDegrees) {
    final transform = GradientRotation(angleInDegrees);

    return LinearGradient(
      colors: colors,
      transform: transform,
    );
  }

  RadialGradient getRadialGradient() {
    return RadialGradient(
      colors: colors,
    );
  }

  SweepGradient getSweepGradient(
      double startAngleInDegrees, double endAngleInDegrees) {
    return SweepGradient(
      colors: colors,
      startAngle: startAngleInDegrees,
      endAngle: endAngleInDegrees,
    );
  }
}

class GradientPalettePresets {
  static final GradientPalette nih = GradientPalette([
    Colors.blue,
    const Color.fromARGB(255, 198, 135, 255),
  ]);

  static final GradientPalette redToYellow = GradientPalette([
    Colors.red,
    Colors.yellow,
  ]);

  static final GradientPalette pinkToPurple = GradientPalette([
    Colors.pink,
    Colors.purple,
  ]);

  static final GradientPalette pinktowhite =
      GradientPalette([const Color.fromARGB(255, 198, 132, 253), Colors.white]);
}

class Colores {
  static const blau = Color.fromARGB(255, 96, 148, 234);
  static const mink = Color.fromARGB(255, 198, 132, 253);
  static const mernk = Color.fromARGB(255, 159, 68, 234);
  static const peri = Color.fromARGB(255, 198, 135, 255);
  static const bleu = Color.fromARGB(255, 22, 125, 255);
  static const coolgray = Color.fromARGB(255, 229, 236, 242);
  static const smokey = Color.fromARGB(255, 217, 217, 217);
  static const gree = Color.fromARGB(255, 123, 221, 120);
  static const skin = Color.fromARGB(255, 237, 182, 188);
  static const libleu = Color.fromARGB(255, 188, 213, 255);
  static const liskin = Color.fromARGB(255, 255, 221, 196);
  static const acqua = Color.fromARGB(255, 141, 189, 173);
  static const qe= Color.fromARGB(255,8, 162, 15);
  static const qm= Color.fromARGB(255,218, 81, 18);
  static const qh= Color.fromARGB(255,144, 6, 3);
}




 Widget divider() {
    return Container(
      alignment: Alignment.center,
      width: 270,
      height: 1,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }

Widget space() {
    return Container(
      alignment: Alignment.center,
      width: 50,
    );
  }
 Widget space1() {
    return Container(
      alignment: Alignment.center,
      width: 25,
    );
  }



  Widget dictionaryItemButton(BuildContext context, String label, Widget page, Color color) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      child: Center(
        child: buttonToPage(context, label, page),
      ),
    );
  }

  Widget buttonToPage(BuildContext context, String label, Widget page) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String label, Widget page, String imagePath) {
    return TextButton.icon(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(imagePath),
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }


  Widget buildButton1(BuildContext context, String label,  callback, String imagePath) {
    return TextButton.icon(
      onPressed: () {
       callback;
      },
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(imagePath),
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }