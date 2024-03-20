import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/content_website_warning_popup.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:aeweb/ui/views/util/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddWebsiteBottomBar extends ConsumerWidget {
  const AddWebsiteBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addWebsite = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    Future<bool> _submitForm() async {
      final addWebsiteNotifier = ref
          .watch(AddWebsiteFormProvider.addWebsiteForm.notifier)
        ..setControlInProgress(true);
      final isNameOk = addWebsiteNotifier.controlName(context);
      final isPathOk = addWebsiteNotifier.controlPath(context);
      final isCertOk = addWebsiteNotifier.controlCert(context);
      var isSiteSizeOk = true;
      if (FeatureFlags.websiteSizeLimit) {
        isSiteSizeOk =
            await addWebsiteNotifier.controlNbOfTransactionFiles(context);
      }
      addWebsiteNotifier.setControlInProgress(false);
      if (isNameOk && isPathOk && isCertOk && isSiteSizeOk) {
        final acceptRules = await ContentWebsiteWarningPopup.getDialog(
          context,
          AppLocalizations.of(context)!.addWebsiteContentWarningHeader,
          AppLocalizations.of(context)!.addWebsiteContentWarningText,
        );
        return acceptRules ?? false;
      }
      return false;
    }

    final session = ref.watch(SessionProviders.session);

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
      child: Row(
        children: [
          if (addWebsite.creationInProgress)
            aedappfm.AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_cancel,
              disabled: true,
            )
          else if (addWebsite.processFinished)
            aedappfm.AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_close,
              onPressed: () {
                context.go(RoutesPath().home());
              },
            )
          else
            aedappfm.AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_cancel,
              onPressed: () {
                context.go(RoutesPath().home());
              },
            ),
          if (session.isConnected)
            if (addWebsite.creationInProgress)
              aedappfm.AppButton(
                labelBtn: AppLocalizations.of(context)!.btn_add_website,
                disabled: true,
              )
            else
              aedappfm.AppButton(
                labelBtn: AppLocalizations.of(context)!.btn_add_website,
                onPressed: () async {
                  final ctlOk = await _submitForm();
                  if (ctlOk) {
                    final addWebsiteNotifier = ref.watch(
                      AddWebsiteFormProvider.addWebsiteForm.notifier,
                    );

                    await addWebsiteNotifier.addWebsite(context, ref);
                  }
                },
              ),
        ],
      ),
    );
  }
}
