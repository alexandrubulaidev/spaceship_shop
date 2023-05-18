import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controller_state.dart';
import '../../../core/global_obs.dart';
import '../../../core/services.dart';
import '../../widgets/rx_builder.dart';
import '../../widgets/spaceship_component_widget.dart';
import '../../widgets/spaceship_details_widget.dart';
import 'spaceship_page_controller.dart';

class SpaceshipPage extends StatefulWidget {
  const SpaceshipPage({super.key});

  @override
  State<SpaceshipPage> createState() => _SpaceshipPageState();
}

class _SpaceshipPageState extends State<SpaceshipPage> {
  final controller = Services.register<SpaceshipPageController>(
    SpaceshipPageController(),
  );

  void _shop(final BuildContext context) {
    context.go('/shop');
  }

  @override
  void initState() {
    super.initState();
    final state = BaseState<String>('testing');
    print(state.value);
    state.listen((event) {
      print(event);
    });
    Future.delayed(Duration(seconds: 1), () {
      state.value = 'testing2';
    });
    Future.delayed(Duration(seconds: 2), () {
      state.value = 'testing3';
    });
  }

  @override
  void dispose() {
    super.dispose();
    Services.unregister<SpaceshipPageController>();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _shop(context);
        },
        child: const FaIcon(
          FontAwesomeIcons.cartPlus,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: RxBuilder(
          subject: controller.state,
          builder: (final context, final value) {
            if (value is ControllerErrored) {
              return Center(
                child: Text(
                  value.message,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            if (value is ControllerIdle) {
              return ListView.builder(
                itemCount: controller.components.length + 1,
                itemBuilder: (final context, final index) {
                  if (index == 0) {
                    return SpaceshipDetailsWidget(
                      spaceship: controller.spaceship,
                    );
                  }
                  final component = controller.components[index - 1];
                  return SpaceshipComponentWidget(
                    component: component,
                    padding: const EdgeInsets.all(5),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
