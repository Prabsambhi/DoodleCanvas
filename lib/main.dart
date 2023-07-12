// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.black;
  double _strokewidth = 4;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colorList = [
    Colors.red,
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.brown
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GestureDetector(
          onPanStart: (details) {
            drawingPoints.add(DrawingPoint(
                details.localPosition,
                Paint()
                  ..color = selectedColor
                  ..isAntiAlias = true
                  ..strokeWidth = _strokewidth
                  ..strokeCap = StrokeCap.round));
          },
          onPanUpdate: (details) {
            setState(() {
              drawingPoints.add(DrawingPoint(
                  details.localPosition,
                  Paint()
                    ..color = selectedColor
                    ..isAntiAlias = true
                    ..strokeWidth = _strokewidth
                    ..strokeCap = StrokeCap.round));
            });
          },
          onPanEnd: (details) {
            setState(() {
              drawingPoints.add(null);
            });
          },
          child: CustomPaint(
            painter: Mypaint(drawingPoints),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 200,
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: _strokewidth / 10,
              onChanged: (value) {
                setState(() {
                  _strokewidth = value * 10;
                });
              },
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 60,
          child: ElevatedButton.icon(
            onPressed: (() {
              setState(() => drawingPoints = []);
            }),
            icon: Icon(Icons.cancel),
            label: Text("Clear"),
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        height: 70,
        color: Color.fromARGB(97, 213, 210, 210),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              colorList.length,
              (index) => colorChoice(colorList[index], selectedColor,
                  () => changeSelectedColor(colorList[index]))),
        ),
      )),
    );
  }

  void changeSelectedColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  Widget colorChoice(Color bgcolor, Color selectedColor, VoidCallback ontap) {
    bool isSelected = selectedColor == bgcolor;
    return GestureDetector(
      onTap: ontap,
      child: Container(
          width: isSelected ? 46 : 42,
          height: isSelected ? 46 : 42,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: bgcolor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.5))),
    );
  }
}

class Mypaint extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  Mypaint(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i] != null || drawingPoints[i + 1] == null) {
        // canvas.drawCircle(drawingPoints[i]!.offset, 2, drawingPoints[i]!.paint);
        // print("Reached end");
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
