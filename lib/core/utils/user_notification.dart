import 'package:flutter/material.dart';

sealed class UserNotification {
  final String message;
  const UserNotification(this.message);
}

final class SuccessNotification extends UserNotification {
  const SuccessNotification(super.message);
}

final class ErrorNotification extends UserNotification {
  const ErrorNotification(super.message);
}

extension NotificationDisplayer on BuildContext {
  void showSnackBarNotification(UserNotification notification) {
    final Color color = switch (notification) {
      SuccessNotification() => Colors.green,
      ErrorNotification() => Colors.red,
    };

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(notification.message),
          backgroundColor: color,
          behavior: .floating,
        ),
      );
  }
}
