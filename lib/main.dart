import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());

}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin{
  late TransformationController controller;
  TapDownDetails ? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;
  @override
  void initState(){
    super.initState();
    controller= TransformationController();
    animationController=AnimationController(vsync: this,
    duration: const Duration(milliseconds: 300))..addListener(() {
      controller.value=animation!.value;
    });
  }
  @override
  void dispose(){
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('ANIMATED ZOOM')),
        ),
        body: Center(
          child:GestureDetector(
            onDoubleTapDown: (details) =>tapDownDetails = details,
            onDoubleTap: (){
              final position= tapDownDetails!.localPosition;
              const double scale=5;
              final x= -position.dx * (scale-1);
              final y= -position.dy * (scale-1);
              final zoomed = Matrix4.identity()
                ..translate(x,y)
                ..scale(scale);

              final end=controller.value.isIdentity() ? zoomed:Matrix4.identity();
              animation= Matrix4Tween(
                begin: controller.value,
                end: end,
              ).animate(
                CurveTween(curve: Curves.easeOut).animate(animationController),
              );
              animationController.forward(from: 0);
            },
            child: InteractiveViewer(
              transformationController: controller,
              clipBehavior: Clip.none,
              panEnabled: false,
              scaleEnabled: false,

              boundaryMargin: const EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 1/2,
                child: Image.network(
                    'https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?cs=srgb&dl=pexels-pixabay-268533.jpg&fm=jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
