import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di_initializer.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies() async => $initGetIt(getIt);
