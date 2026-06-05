import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class IConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements IConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);
  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
