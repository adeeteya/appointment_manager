import 'package:hive/hive.dart';

part 'appointment.g.dart';

@HiveType(typeId: 1)
class Appointment {
  @HiveField(0)
  String clientName;
  @HiveField(1)
  String address;
  @HiveField(2)
  String? additionalInformation;
  @HiveField(3)
  AppointmentType appointmentType;
  @HiveField(4)
  DateTime dateTime;
  @HiveField(5)
  int mobileNumber;

  Appointment(this.clientName, this.address, this.appointmentType,
      this.dateTime, this.mobileNumber,
      {this.additionalInformation});

  String serviceEmoji() {
    switch (appointmentType.index) {
      case 0:
        return '🪳';
      case 1:
        return '🐜';
      case 2:
        return '🐀 ';
      case 3:
        return '🧹';
      default:
        return '🪳';
    }
  }

  String serviceText() {
    switch (appointmentType.index) {
      case 0:
        return 'General Pest Control';
      case 1:
        return 'Termite Treatment';
      case 2:
        return 'Rodent Treatment';
      case 3:
        return 'Sanitization Service';
      default:
        return 'General Pest Control';
    }
  }

  String dateAndTimeString() {
    String result = "";
    switch (dateTime.month) {
      case 1:
        result = "January";
        break;
      case 2:
        result = "February";
        break;
      case 3:
        result = "March";
        break;
      case 4:
        result = "April";
        break;
      case 5:
        result = "May";
        break;
      case 6:
        result = "June";
        break;
      case 7:
        result = "July";
        break;
      case 8:
        result = "August";
        break;
      case 9:
        result = "September";
        break;
      case 10:
        result = "October";
        break;
      case 11:
        result = "November";
        break;
      case 12:
        result = "December";
        break;
      default:
        result = "January";
    }
    result +=
        " ${dateTime.day},  ${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
    return result;
  }
}

@HiveType(typeId: 2)
enum AppointmentType {
  @HiveField(0)
  generalPestControl,
  @HiveField(1)
  termiteTreatment,
  @HiveField(2)
  rodentTreatment,
  @HiveField(3)
  sanitizationService
}
