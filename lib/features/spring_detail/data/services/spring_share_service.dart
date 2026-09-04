import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class SpringShareService {
  Future<void> share({required String text, required String subject});
}

class SharePlusSpringShareService implements SpringShareService {
  const SharePlusSpringShareService();

  @override
  Future<void> share({required String text, required String subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }
}

final springShareServiceProvider = Provider<SpringShareService>(
  (_) => const SharePlusSpringShareService(),
);
