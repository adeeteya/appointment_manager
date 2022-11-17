import 'package:appointment_manager/constants.dart';
import 'package:appointment_manager/models/appointment.dart';
import 'package:appointment_manager/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppointmentFormScreen extends StatefulWidget {
  final int? index;
  final Appointment? appointment;
  const AppointmentFormScreen({Key? key, this.index, this.appointment})
      : super(key: key);

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController dateTextController;
  late final TextEditingController timeTextController;
  Box appointmentsBox = Hive.box<Appointment>('appointments');
  TimeOfDay time = TimeOfDay(hour: TimeOfDay.now().hour, minute: 0);
  DateTime date = DateTime.now().add(const Duration(days: 1));
  String? address = "";
  String? name = "";
  int? mobileNumber;
  String? additionalInformation;
  AppointmentType appointmentType = AppointmentType.generalPestControl;
  @override
  void initState() {
    if (widget.appointment != null) {
      name = widget.appointment!.clientName;
      address = widget.appointment!.address;
      mobileNumber = widget.appointment!.mobileNumber;
      additionalInformation = widget.appointment?.additionalInformation;
      appointmentType = widget.appointment!.appointmentType;
      date = widget.appointment!.dateTime;
      time = TimeOfDay(
        hour: widget.appointment!.dateTime.hour,
        minute: widget.appointment!.dateTime.minute,
      );
    }
    dateTextController =
        TextEditingController(text: "${date.day}/${date.month}/${date.year}");
    timeTextController = TextEditingController(
        text:
            "${time.hourOfPeriod}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour >= 12 ? 'PM' : 'AM'}");
    super.initState();
  }

  @override
  void dispose() {
    dateTextController.dispose();
    timeTextController.dispose();
    super.dispose();
  }

  void _onTapOutside() {
    FocusScope.of(context).unfocus();
  }

  void _onNameChanged(String val) {
    name = val;
  }

  void _onMobileNumberChanged(String val) {
    mobileNumber = int.parse(val);
  }

  void _onAddressChanged(String val) {
    address = val;
  }

  String? _nameValidator(String? val) {
    return (val?.isEmpty ?? true) ? "Please enter the client's name" : null;
  }

  String? _mobileNumberValidator(String? val) {
    if (val?.isEmpty ?? true) {
      return "Please enter the client's phone number";
    } else if (val!.length != 10) {
      return "Enter a valid phone number";
    }
    return null;
  }

  String? _addressValidator(String? val) {
    return (val?.isEmpty ?? true) ? "Please enter the client's address" : null;
  }

  void _onTreatmentChanged(AppointmentType? val) {
    appointmentType = val!;
  }

  void _onDateChanged() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (newDate != null) {
      date = newDate;
      dateTextController.text = "${date.day}/${date.month}/${date.year}";
    }
  }

  void _onTimeChanged() async {
    TimeOfDay? newTime =
        await showTimePicker(context: context, initialTime: time);
    if (newTime != null) {
      time = newTime;
      timeTextController.text =
          "${time.hourOfPeriod}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour >= 12 ? 'PM' : 'AM'}";
    }
  }

  void _onAdditionalInformationChanged(String val) {
    additionalInformation = val;
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      address = address!.trim();
      date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (date.compareTo(DateTime.now()) <= 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Date should be in the future."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
        return;
      }
      int boxKey;
      if (widget.appointment != null) {
        boxKey = appointmentsBox.keyAt(widget.index!);
        await appointmentsBox.putAt(
          widget.index!,
          Appointment(
            name!,
            address!,
            appointmentType,
            date,
            mobileNumber!,
            additionalInformation: additionalInformation,
          ),
        );
      } else {
        boxKey = await appointmentsBox.add(Appointment(
            name!, address!, appointmentType, date, mobileNumber!,
            additionalInformation: additionalInformation));
      }
      _setNotifications(boxKey);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _setNotifications(int boxKey) {
    if (DateTime.now().compareTo(date.subtract(const Duration(days: 1))) < 0) {
      NotificationService.showScheduledNotification(
        int.parse("1$boxKey"),
        "Appointment Alert",
        "Appointment for $name is due tomorrow at ${timeTextController.text}",
        null,
        date.subtract(const Duration(days: 1)),
      );
    }
    if (DateTime.now().compareTo(date.subtract(const Duration(hours: 4))) < 0) {
      NotificationService.showScheduledNotification(
        int.parse("2$boxKey"),
        "Appointment Alert",
        "Appointment for $name is due in 4 hours",
        null,
        date.subtract(const Duration(hours: 4)),
      );
    }
    if (DateTime.now().compareTo(date.subtract(const Duration(hours: 2))) < 0) {
      NotificationService.showScheduledNotification(
        int.parse("3$boxKey"),
        "Appointment Alert",
        "Appointment for $name is due in 2 hours",
        null,
        date.subtract(const Duration(hours: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapOutside,
      child: Scaffold(
        appBar: AppBar(
          title: (widget.appointment != null)
              ? const Text("Edit Appointment")
              : const Text("Add Appointment"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: _onNameChanged,
                  validator: _nameValidator,
                  initialValue: name,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: kInputDecoration.copyWith(
                    labelText: "Name",
                    prefixIcon: const Icon(
                      Icons.person,
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: _onMobileNumberChanged,
                  validator: _mobileNumberValidator,
                  initialValue: mobileNumber == null ? null : "$mobileNumber",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  cursorColor: kPrimaryColor,
                  decoration: kInputDecoration.copyWith(
                    counterText: "",
                    labelText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone),
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: _onAddressChanged,
                  validator: _addressValidator,
                  initialValue: address,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.newline,
                  cursorColor: kPrimaryColor,
                  minLines: 2,
                  maxLines: 3,
                  decoration: kInputDecoration.copyWith(
                    labelText: "Address",
                    prefixIcon: const Icon(
                      Icons.home,
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: _onAdditionalInformationChanged,
                  initialValue: additionalInformation,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryColor,
                  minLines: 2,
                  maxLines: 3,
                  decoration: kInputDecoration.copyWith(
                    labelText: "Additional Information",
                    hintText: "(optional)",
                    prefixIcon: const Icon(
                      Icons.try_sms_star,
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<AppointmentType>(
                  onChanged: _onTreatmentChanged,
                  value: appointmentType,
                  focusColor: kPrimaryColor,
                  decoration: kInputDecoration.copyWith(),
                  dropdownColor: Theme.of(context).brightness == Brightness.dark
                      ? kDarkColor
                      : Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: AppointmentType.generalPestControl,
                      child: Text("🪳  General Pest Control"),
                    ),
                    DropdownMenuItem(
                      value: AppointmentType.rodentTreatment,
                      child: Text("🐀  Rodent Treatment"),
                    ),
                    DropdownMenuItem(
                      value: AppointmentType.sanitizationService,
                      child: Text("🧹  Sanitization Service"),
                    ),
                    DropdownMenuItem(
                      value: AppointmentType.termiteTreatment,
                      child: Text("🐜  Termite Treatment"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        onTap: _onDateChanged,
                        controller: dateTextController,
                        keyboardType: TextInputType.none,
                        showCursor: false,
                        enableInteractiveSelection: false,
                        decoration: kInputDecoration.copyWith(
                          labelText: "Date",
                          prefixIcon: const Icon(
                            Icons.event,
                          ),
                          labelStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: TextFormField(
                        onTap: _onTimeChanged,
                        keyboardType: TextInputType.none,
                        controller: timeTextController,
                        showCursor: false,
                        enableInteractiveSelection: false,
                        decoration: kInputDecoration.copyWith(
                          labelText: "Time",
                          prefixIcon: const Icon(
                            Icons.schedule,
                          ),
                          labelStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: (widget.appointment != null)
                        ? const Text("Edit")
                        : const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
