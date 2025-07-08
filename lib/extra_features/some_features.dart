import 'package:flutter/material.dart';

class Features {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade400),
    );
  }

  static void progressionBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  static readableTime({required BuildContext ctx, required String time}) {
    final exactTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(exactTime).format(ctx);
  }
}
