import 'package:flutter/material.dart';
import 'package:hover_menu/hover_menu_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HoverMenu(),
    );
  }
}

class HoverMenu extends StatelessWidget {
  const HoverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const texts = ['text', 'body', 'head'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Spacer(),
            ...List.generate(
              6,
              (_) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: HoverMenuWidget(
                  texts: texts,
                  menuTitle: 'select',
                  onItemTap: (index) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(texts[index])),
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
