import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final hiveBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError(); // Will be overridden in main
});