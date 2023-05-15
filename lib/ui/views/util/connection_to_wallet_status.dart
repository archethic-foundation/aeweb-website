import 'dart:math';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ConnectionToWalletStatus extends ConsumerStatefulWidget {
  const ConnectionToWalletStatus({
    super.key,
  });

  @override
  ConsumerState<ConnectionToWalletStatus> createState() =>
      _ConnectionToWalletStatusState();
}

class _ConnectionToWalletStatusState
    extends ConsumerState<ConnectionToWalletStatus> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final session = ref.watch(SessionProviders.session);
    final sessionNotifier = ref.watch(SessionProviders.session.notifier);

    return session.isConnectedToWallet == false
        ? OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide.none),
            ),
            onPressed: () async {
              await sessionNotifier.connectToWallet();

              if (session.error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      session.error,
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[
                    Color(0xFF00A4DB),
                    Color(0xFFCC00FF),
                  ],
                  transform: GradientRotation(pi / 9),
                ),
                shape: const StadiumBorder(),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 7,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.empty_wallet,
                    color: Theme.of(context).textTheme.labelMedium!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.connectionWalletConnect,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium!.color,
                      fontFamily: 'Equinox',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.empty_wallet_tick,
                        color: Colors.green,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.nameAccount,
                        style: textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                IconButtonAnimated(
                  onPressed: () async {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return ScaffoldMessenger(
                          child: Builder(
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                content: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .confirmationPopupTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .connectionWalletDisconnectWarning,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                          bottom: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .no,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await sessionNotifier
                                                    .cancelConnection();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.power_settings_new_rounded),
                  color: Colors.red,
                  tooltip:
                      AppLocalizations.of(context)!.connectionWalletDisconnect,
                ),
              ],
            ),
          );
  }
}
