import 'package:appointment_manager/constants.dart';
import 'package:appointment_manager/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  const AppointmentTile(
      {Key? key,
      required this.appointment,
      required this.onDelete,
      required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  appointment.serviceEmoji(),
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.clientName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse("tel:${appointment.mobileNumber}"));
                      },
                      child: Text(
                        "+91 ${appointment.mobileNumber}",
                        style:
                            const TextStyle(fontSize: 16, color: kPrimaryColor),
                      ),
                    ),
                    Text(
                      appointment.serviceText(),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.dateAndTimeString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        appointment.address,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onUpdate,
                  icon: const Icon(
                    Icons.change_circle,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            if (appointment.additionalInformation != null &&
                appointment.additionalInformation!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Additional Information: ${appointment.additionalInformation!}",
                  style: const TextStyle(color: Colors.grey),
                ),
              )
          ],
        ),
      ),
    );
  }
}
