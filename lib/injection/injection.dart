import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/app/app_routes.dart';

final sl = GetIt.instance; // Ensure you're using the correct GetIt instance

Future<void> setupInjection() async {
  sl.registerSingleton<GoRouter>(buildRouter());
}
