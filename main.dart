import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final textProvider = Provider((ref) => "Hello Provider in a previous version.");
final visibilityProvider = ChangeNotifierProvider((ref) => Visible());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Consumer(builder: (context, watch, _) {
              final String val = watch(textProvider);
              final bool isVisible = watch(visibilityProvider).isVisible;
              return Visibility(
                visible: isVisible,
                child: Text(val),
              );
            }),
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(),
                    ),
                  ),
              child: const Text('Go to next screen'))
        ],
      ),
    );
  }
}

class Visible extends ChangeNotifier {
  bool isVisible = true;

  void makeInvisible() {
    isVisible = !isVisible;
    notifyListeners();
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(builder: (context, watch, _) {
          final isVisible = watch(visibilityProvider.notifier);
          return ElevatedButton(
              onPressed: () {
                isVisible.makeInvisible();
                Navigator.pop(context);
              },
              child: const Text('Make inVisible'));
        }),
      ),
    );
  }
}
