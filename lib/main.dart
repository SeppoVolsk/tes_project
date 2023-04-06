import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SquareAnimation(),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  static const squareSize = 100.0;
  late AnimationController controller;
  late Animation<Offset> containerAnimation;

  final centerPoint = const Offset(0.0, 0.0);
  late final Offset rightSide;
  late final Offset leftSide;
  late Offset startPoint;

  bool get rightDisabled => controller.isAnimating || startPoint == rightSide;
  bool get leftDisabled => controller.isAnimating || startPoint == leftSide;

  void setMoveDirection({required Offset direction}) {
    controller.reset();
    setState(() {
      containerAnimation = Tween<Offset>(begin: startPoint, end: direction)
          .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    });
    if (startPoint != direction) controller.forward();
    startPoint = direction;
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    startPoint = centerPoint;
    setMoveDirection(direction: centerPoint);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final halfScreenWidth = MediaQuery.of(context).size.width / 2;
    final ratio = (halfScreenWidth / squareSize) - 0.5;
    rightSide = Offset(ratio, 0.0);
    leftSide = Offset(-ratio, 0.0);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 500,
            child: Stack(
              children: [
                SlideTransition(
                  position: containerAnimation,
                  child: Container(
                    width: squareSize,
                    height: squareSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () => leftDisabled
                        ? {}
                        : setMoveDirection(direction: leftSide),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            leftDisabled ? Colors.grey : Colors.blue),
                    child: const Icon(Icons.arrow_back_outlined)),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () => rightDisabled
                        ? {}
                        : setMoveDirection(direction: rightSide),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            rightDisabled ? Colors.grey : Colors.blue),
                    child: const Icon(Icons.arrow_forward_outlined)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
