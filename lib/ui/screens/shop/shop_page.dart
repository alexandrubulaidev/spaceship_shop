import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/controller_state.dart';
import '../../../core/services.dart';
import '../../../model/spaceship_shop_component.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/date_extensions.dart';
import '../../../utils/logging.dart';
import '../../../utils/string_utils.dart';
import '../../dialogs/simple_alert_dialog.dart';
import '../../dialogs/simple_alert_dialog_templates.dart';
import '../../widgets/checkout_component.dart';
import '../../widgets/rx_builder.dart';
import '../../widgets/spaceship_component_widget.dart';
import 'shop_page_controller.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    super.key,
  });

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final controller = Services.register<ShopPageController>(
    ShopPageController(),
  );

  @override
  void dispose() {
    super.dispose();
    Services.unregister<ShopPageController>();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Ship'.localized,
        ),
      ),
      body: RxBuilder(
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

          return _StepperWidget();
        },
      ),
    );
  }
}

class _StepperWidget extends StatelessWidget {
  ShopPageController get controller => Services.get<ShopPageController>();

  void _onNext(final BuildContext context) {
    final shopState = controller.shopState.value;
    final total = controller.totalCost;
    if (shopState == ShopState.components) {
      if (total == 0) {
        unawaited(
          showSimpleAlertDialog(
            context: context,
            dialog: SimpleAlertDialog(
              title: 'Cart Empty'.localized,
              message:
                  'Your shopping cart is empty. Add some components first!',
              actions: [
                SimpleAction(text: 'Ok'.localized),
              ],
            ),
          ),
        );
      } else {
        unawaited(
          showSimpleAlertDialog(
            context: context,
            dialog: SimpleAlertDialog(
              title: 'Total Price'.localized,
              message: StringUtils.formatted(
                r'Your total price for the selected components is %s$'
                    .localized,
                [total.toStringAsFixed(0)],
              ),
              actions: [
                SimpleAction(
                  text: 'Back',
                  color: Colors.red,
                ),
                SimpleAction(
                  text: 'Ok'.localized,
                  onTap: controller.showServiceDateStep,
                ),
              ],
            ),
          ),
        );
      }
    } else {
      unawaited(
        showSimpleAlertDialog(
          context: context,
          dialog: SimpleAlertDialog(
            title: 'Confirm Appointment'.localized,
            message: StringUtils.formatted(
              r'Your appointment time is %s and your total cost is %s$',
              [
                controller.appointmentDate.niceDateTimeString,
                total.toStringAsFixed(0),
              ],
            ),
            actions: [
              SimpleAction(
                text: 'Back',
                color: Colors.red,
              ),
              SimpleAction(
                text: 'Ok'.localized,
                onTap: () {
                  context.push('/stations');
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return RxBuilder(
      subject: controller.shopState,
      builder: (final context, final value) {
        final index = value?.index ?? 0;
        return Stepper(
          type: StepperType.horizontal,
          currentStep: index,
          // onStepTapped: (final index) {},
          onStepContinue: () {
            _onNext(context);
          },
          onStepCancel: () {
            if (index == 0) {
              context.pop();
            } else {
              controller.showComponentsStep();
            }
          },
          steps: [
            Step(
              title: Text(
                'Add Components'.localized,
              ),
              content: _ComponentsShopWidget(
                height: height * .66,
              ),
              isActive: index == 0,
            ),
            Step(
              title: Text('Select Service Date'.localized),
              content: _DatePickerWidget(),
              isActive: index == 1,
            ),
          ],
        );
      },
    );
  }
}

class _DatePickerWidget extends StatefulWidget {
  @override
  State<_DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<_DatePickerWidget> {
  ShopPageController get controller => Services.get<ShopPageController>();

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // I def. not going to create a schedule picker for this right now
        // This package looks pretty enough
        // Ideally we would want to wrap it a custom widget
        SfCalendar(
          minDate: DateTime.now(),
          view: CalendarView.week,
          initialSelectedDate: controller.appointmentDate,
          initialDisplayDate: controller.appointmentDate,
          onTap: (final calendarTapDetails) {
            final date = calendarTapDetails.date;
            Logs.debug(date);
            if (date != null) {
              controller.appointmentDate = date;
            }
            setState(() {});
          },
        ),
        const SizedBox(height: 30),
        Text(
          StringUtils.formatted(
            'Schedule appointment for %s'.localized,
            [controller.appointmentDate.niceDateTimeString],
          ),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}

class _ComponentsShopWidget extends StatelessWidget {
  const _ComponentsShopWidget({
    required this.height,
  });

  final double height;

  void _showBottomSheet({
    required final BuildContext context,
    required final SpaceshipShopComponent component,
  }) {
    final controller = Services.get<ShopPageController>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (final context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: SafeArea(
              child: CheckoutComponent(
                component: component,
                items: controller.getItemCount(
                  item: component,
                ),
                onChange: (final count) {
                  controller.updateItemCount(
                    item: component,
                    count: count,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final controller = Services.get<ShopPageController>();

    return RxBuilder(
      subject: controller.fetchingComponents,
      builder: (final context, final value) {
        final loading = value ?? true;
        final components = controller.components;
        if (loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: ListView.builder(
              itemCount: components.length,
              itemBuilder: (final context, final index) {
                final component = components[index];
                return GestureDetector(
                  onTap: () {
                    _showBottomSheet(
                      component: component,
                      context: context,
                    );
                  },
                  child: ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: SpaceshipComponentWidget(
                      padding: const EdgeInsets.all(5),
                      component: component.toSpaceshipComponent(),
                      price: '${component.price.toStringAsFixed(0)}\$',
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
