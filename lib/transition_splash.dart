import 'package:flutter/material.dart';

class TransitionSplash extends StatefulWidget {
  final Widget nextPage;
  final Duration duration;
  final String? message;
  final Color backgroundColor;

  const TransitionSplash({
    Key? key,
    required this.nextPage,
    this.duration = const Duration(seconds: 2),
    this.message,
    this.backgroundColor = const Color.fromARGB(255, 255, 136, 0),
  }) : super(key: key);

  @override
  State<TransitionSplash> createState() => _TransitionSplashState();
}

class _TransitionSplashState extends State<TransitionSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.nextPage),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              widget.message ?? 'Loading...',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
