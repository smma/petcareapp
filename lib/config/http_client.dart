import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Returns an [http.Client] configured for the current build mode.
///
/// In debug builds on Android/iOS, TLS certificate errors are bypassed so the
/// app can reach the backend when running on emulators or simulators whose
/// trust store may not include all required certificate authorities.
///
/// In release builds, full standard TLS validation always applies — the
/// permissive callback is tree-shaken out and never ships to end users.
http.Client createHttpClient() {
  if (kDebugMode && (Platform.isAndroid || Platform.isIOS)) {
    final inner = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    return IOClient(inner);
  }
  return http.Client();
}
