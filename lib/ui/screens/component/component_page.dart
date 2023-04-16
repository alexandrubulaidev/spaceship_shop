import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services.dart';
import 'component_page_controller.dart';

class ComponentPage extends StatefulWidget {
  const ComponentPage({
    this.id,
    super.key,
  });

  final String? id;

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  ComponentPageController get controller =>
      Services.register(ComponentPageController(id: widget.id));

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Text('test-${controller.id}'),
          onTap: () {
            context.go('/component/2');
          },
        ),
      ),
    );
  }
}
