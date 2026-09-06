import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/platform/app_info_service.dart';

part 'package_app_info_service.g.dart';

class PackageAppInfoService implements AppInfoService {
  const PackageAppInfoService();

  @override
  Future<String> loadVersion() async =>
      (await PackageInfo.fromPlatform()).version;
}

@riverpod
AppInfoService appInfoService(Ref ref) => const PackageAppInfoService();

@riverpod
Future<String> appVersion(Ref ref) =>
    ref.watch(appInfoServiceProvider).loadVersion();
