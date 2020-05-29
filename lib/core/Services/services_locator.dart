import 'package:get_it/get_it.dart';
import 'package:urawai_pos/core/Services/connectivity_service.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';

class ServiceLocator {
  final GetIt locator = GetIt.instance;

  setup() {
    locator.registerLazySingleton<FirebaseAuthentication>(
        () => FirebaseAuthentication());
    locator.registerLazySingleton<FirestoreServices>(() => FirestoreServices());
    locator.registerLazySingleton<ConnectivityService>(
        () => ConnectivityService());
  }
}
