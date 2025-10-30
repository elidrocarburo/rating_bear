import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rive/rive.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  StateMachineController? controller;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  
  // Variable para controlar la puntuación actual
  double _currentRating = 0;
  
  // Clave única para el widget RiveAnimation
  UniqueKey _riveKey = UniqueKey();

  // Método para resetear la animación
  void _resetAnimation() {
    setState(() {
      // Cambiar la clave fuerza la recreación del widget Rive
      _riveKey = UniqueKey();
    });
  }

  // Método para manejar el cambio de rating
  void _onRatingUpdate(double rating) {
    // Primero reiniciamos la animación
    _resetAnimation();
    
    // Luego actualizamos el rating y disparamos la animación correspondiente
    setState(() {
      _currentRating = rating;
    });
    
    // Disparamos la animación después de un pequeño delay para que se reinicie primero
    Future.delayed(Duration(milliseconds: 100), () {
      if (rating == 1 || rating == 2) {
        trigFail?.fire();
      } else if (rating >= 3) {
        trigSuccess?.fire();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 250,
                child: RiveAnimation.asset(
                  key: _riveKey, // Usar la clave única
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                        artboard, "Login Machine");
                    if (controller == null) return;
                    artboard.addController(controller!);
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                  },
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Enjoying Sounter?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: size.width,
                child: Text(
                  'With how many stars do you rate your experience. \n Tap a star to rate!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black54
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: _currentRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context,_)=>Icon(Icons.star, color: Colors.amber,), 
                        onRatingUpdate: _onRatingUpdate, // Usar el método mejorado
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                onPressed: (){},
                child: Text(
                  'Rate now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){}, 
                      child: Text(
                        'No thanks',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ))
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}