import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';

final legalOnboardingProvider =
    NotifierProvider<LegalOnboardingController, bool>(
      LegalOnboardingController.new,
    );

class LegalOnboardingController extends Notifier<bool> {
  static const String _acknowledgedKey = 'legal_onboarding_ack_v1';

  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(_acknowledgedKey) ??
        false;
  }

  Future<void> acknowledge() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(_acknowledgedKey, true);
  }
}
