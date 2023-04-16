import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controller_state.dart';
import '../../../core/services.dart';
import '../../../model/spaceship_station.dart';
import '../../../services/shopping_service.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/date_extensions.dart';
import '../../../utils/string_utils.dart';
import '../../dialogs/simple_alert_dialog.dart';
import '../../dialogs/simple_alert_dialog_templates.dart';
import '../../widgets/behavior_subject_builder.dart';
import '../../widgets/segmented_control.dart';
import '../../widgets/spaceship_details_widget.dart';
import '../../widgets/online_image.dart';
import 'stations_page_controller.dart';

class StationsPage extends StatefulWidget {
  const StationsPage({
    super.key,
  });

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  final controller = Services.register<StationsPageController>(
    StationsPageController(),
  );

  // this is the end for this project .. ill just show a dialog go to root
  void _gotoCheckout() {
    final message = StringUtils.formatted(
      r'Your total cost for this order is %s$.',
      [controller.totalCost.toStringAsFixed(0)],
    );
    unawaited(
      showSimpleAlertDialog(
        context: context,
        dialog: SimpleAlertDialog(
          title: 'Total'.localized,
          message: message,
          actions: [
            SimpleAction(
              text: 'Continue to Payment',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                final service = Services.get<ShoppingService>();
                service.clearCart();
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _stationSelected(final SpaceshipStation station) {
    final message = StringUtils.formatted(
      r'Schedule maintenance with %s for %s$?',
      [station.name, station.price.toStringAsFixed(0)],
    );
    unawaited(
      showSimpleAlertDialog(
        context: context,
        dialog: SimpleAlertDialog(
          title: 'Confirmation'.localized,
          message: message,
          actions: [
            SimpleAction(
              text: 'Cancel',
              color: Theme.of(context).colorScheme.error,
            ),
            SimpleAction(
              text: 'Yes',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                controller.confirmReservation(station: station);
                _gotoCheckout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Services.unregister<StationsPageController>();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Repair Station'.localized,
        ),
      ),
      body: BehaviorSubjectBuilder(
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StationsHeader(),
                Expanded(
                  child: _StationList(
                    onSelect: _stationSelected,
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _StationsHeader extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final controller = Services.get<StationsPageController>();
    final spaceship = controller.spaceship;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            StringUtils.formatted(
              'Appointment X',
              [controller.appointmentDate.niceDateTimeString],
            ),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            controller.appointmentDate.niceDateTimeString,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                    maxHeight: 200,
                  ),
                  child: OnlineImage(
                    placeholder: 'assets/spaceship.jpg',
                    picture: spaceship?.picture,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    spaceship?.name ?? 'UNNAMED'.localized,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${'Model'.localized}: ${spaceship?.model ?? 'N/A'.localized}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: 'Search for repair station'.localized,
            ),
          ),
          const SizedBox(height: 10),
          SegmentControl(
            height: 30,
            borderColor: Theme.of(context).colorScheme.primary,
            activeBackgroundColor: Theme.of(context).colorScheme.primary,
            activeTitleColor: Theme.of(context).scaffoldBackgroundColor,
            normalTitleColor: Theme.of(context).colorScheme.primary,
            normalBackgroundColor: Colors.transparent,
            radius: 3,
            tabs: StationsSort.values.map((final value) {
              return value.text;
            }).toList(),
            selected: (final value) {
              controller.filter(sortOrder: StationsSort.values[value]);
            },
          ),
        ],
      ),
    );
  }
}

class _StationList extends StatelessWidget {
  const _StationList({
    this.onSelect,
  });

  final void Function(SpaceshipStation station)? onSelect;

  @override
  Widget build(final BuildContext context) {
    final controller = Services.get<StationsPageController>();

    return BehaviorSubjectBuilder(
      subject: controller.fetchingStations,
      builder: (final context, final value) {
        final loading = value ?? true;
        if (loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return BehaviorSubjectBuilder(
          subject: controller.stations,
          builder: (final context, final value) {
            final stations = value ?? [];
            return ListView.builder(
              itemCount: stations.length,
              itemBuilder: (final context, final index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: InkWell(
                    onTap: () {
                      onSelect?.call(stations[index]);
                    },
                    child: _StationListItem(
                      station: stations[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _StationListItem extends StatelessWidget {
  const _StationListItem({
    required this.station,
  });

  final SpaceshipStation station;

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 5,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.apply(fontWeightDelta: 2),
                          ),
                          Text(
                            station.address,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Text(
                            StringUtils.formatted(
                              r'Estimated price: %s$'.localized,
                              [station.price.toStringAsFixed(0)],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 15,
                              color: Colors.orange[300],
                            ),
                            Text(
                              station.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          StringUtils.formatted(
                            '%s min'.localized,
                            [station.serviceDuration.toStringAsFixed(0)],
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: OnlineImage(
                placeholder: 'assets/station.jpg',
                picture: station.picture,
              ),
            )
          ],
        ),
      ),
    );
  }
}
