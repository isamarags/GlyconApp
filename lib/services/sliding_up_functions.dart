import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/InsertBloodGlucose.dart';
import 'package:glycon_app/Widgets/InsertInsulin.dart';
import 'package:glycon_app/Widgets/InsertPill.dart';
import 'package:glycon_app/Widgets/InsertFood.dart';

void closeAllModals(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void showSlidingUpBloodGlucose(BuildContext context, String userId,
    VoidCallback onDataRegisteredCallback) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return InsertBloodGlucose(
        userId: userId,
        onDataRegistered: () {
          onDataRegisteredCallback();
        },
        closeOptionsPanel: () {
          Navigator.pop(
              context); // Fecha o sliding up panel do InsertBloodGlucose
        },
      );
    },
  );
}

void showSlidingUpInsulin(BuildContext context, String userId,
    VoidCallback onDataRegisteredCallback) {
  closeAllModals(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) {
      return InsertInsulin(
        onDataRegistered: () {
          onDataRegisteredCallback();
        },
        closeOptionsPanel: () {
          Navigator.pop(context);
        },
        userId: userId,
      );
    },
  );
}

void showSlidingUpPill(BuildContext context, String userId,
    VoidCallback onDataRegisteredCallback) {
  closeAllModals(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) {
      return InsertPill(
        userId: userId,
        onDataRegistered: () {
          onDataRegisteredCallback();
        },
        closeOptionsPanel: () {
          Navigator.pop(
              context); // Fecha o sliding up panel do InsertBloodGlucose
        },
      );
    },
  );
}

void showSlidingUpFood(BuildContext context, String userId,
    VoidCallback onDataRegisteredCallback) {
  closeAllModals(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) {
      return InsertFood(
        onDataRegistered: () {
          onDataRegisteredCallback();
        },
        closeOptionsPanel: () {
          Navigator.pop(context);
        },
        userId: userId,
      );
    },
  );
}
