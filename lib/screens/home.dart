import 'package:appointment_manager/models/appointment.dart';
import 'package:appointment_manager/screens/appointment_form.dart';
import 'package:appointment_manager/services/notification_service.dart';
import 'package:appointment_manager/widgets/appointment_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  final bool isDarkMode;
  const Home({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _toAddScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AppointmentFormScreen(),
      ),
    );
  }

  void _switchMode() {
    Hive.box('systemPreferences').put('darkMode', !widget.isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        actions: [
          IconButton(
            onPressed: _switchMode,
            icon: widget.isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toAddScreen,
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box<Appointment>('appointments').listenable(),
        builder: (context, appointmentsBox, _) {
          if (appointmentsBox.isEmpty) {
            return const Center(
              child: Text(
                "No Appointments at the moment",
              ),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: appointmentsBox.length,
            itemBuilder: (context, index) {
              return AppointmentTile(
                appointment: appointmentsBox.getAt(index),
                onDelete: () {
                  int boxKey = appointmentsBox.keyAt(index);
                  appointmentsBox.deleteAt(index);
                  NotificationService.cancelNotification(int.parse("1$boxKey"));
                  NotificationService.cancelNotification(int.parse("2$boxKey"));
                  NotificationService.cancelNotification(int.parse("3$boxKey"));
                },
                onUpdate: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentFormScreen(
                        index: index,
                        appointment: appointmentsBox.getAt(index),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
