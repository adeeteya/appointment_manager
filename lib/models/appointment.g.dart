// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentAdapter extends TypeAdapter<Appointment> {
  @override
  final int typeId = 1;

  @override
  Appointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointment(
      fields[0] as String,
      fields[1] as String,
      fields[3] as AppointmentType,
      fields[4] as DateTime,
      fields[5] as int,
      additionalInformation: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Appointment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.clientName)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.additionalInformation)
      ..writeByte(3)
      ..write(obj.appointmentType)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.mobileNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppointmentTypeAdapter extends TypeAdapter<AppointmentType> {
  @override
  final int typeId = 2;

  @override
  AppointmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppointmentType.generalPestControl;
      case 1:
        return AppointmentType.termiteTreatment;
      case 2:
        return AppointmentType.rodentTreatment;
      case 3:
        return AppointmentType.sanitizationService;
      default:
        return AppointmentType.generalPestControl;
    }
  }

  @override
  void write(BinaryWriter writer, AppointmentType obj) {
    switch (obj) {
      case AppointmentType.generalPestControl:
        writer.writeByte(0);
        break;
      case AppointmentType.termiteTreatment:
        writer.writeByte(1);
        break;
      case AppointmentType.rodentTreatment:
        writer.writeByte(2);
        break;
      case AppointmentType.sanitizationService:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
