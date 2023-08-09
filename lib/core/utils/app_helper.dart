import 'package:uuid/uuid.dart';

class AppHelper {
  static String v4UUIDWithoutDashes() {
    const uuid = Uuid();
    final v4 = uuid.v4();
    final v4WithoutDashes = v4.replaceAll('-', '');
    return v4WithoutDashes;
  }
}
