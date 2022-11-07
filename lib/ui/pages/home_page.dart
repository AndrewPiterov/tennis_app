import 'package:flutter/material.dart';
import 'package:tennis_app/ui/widgets/player_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis App'),
      ),
      body: Row(
        children: const [
          Expanded(child: PlayerView(1)),
          Expanded(child: PlayerView(2)),
        ],
      ),
    );
  }
}
