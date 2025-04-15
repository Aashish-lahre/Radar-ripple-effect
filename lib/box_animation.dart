import 'package:flutter/material.dart';

class BoxAnimation extends StatefulWidget {
  const BoxAnimation({super.key});

  @override
  State<BoxAnimation> createState() => _BoxAnimationState();
}

class _BoxAnimationState extends State<BoxAnimation> with SingleTickerProviderStateMixin {
  late  AnimationController _controller;
  late Animation<Color> colorAnimation;
  late Animation<int> radiusAnimation;
  final  ColorTween colorTween = ColorTween(begin: Colors.green[600], end: Colors.green[300]);
  final  IntTween radiusTween = IntTween(begin: 10, end: 50);

  @override
  void initState() {
    super.initState();
     _controller= AnimationController(vsync: this, duration: Duration(seconds: 1));
    
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }


  Widget customContainer({
    required double radius,
    required double borderWidth,
    required Color borderColor,
  }) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
    );
  }



  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: CircleAvatar(backgroundColor: Colors.orange, radius: 10,),
                ),
              ),
              ...List.generate(3, (index) {
                return Positioned.fill(
                  child: Center(
                    child: customContainer(radius: index == 1 ? 30 : 20, borderWidth: 5, borderColor: Colors.teal),
                  ),

                );
              }),

            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
