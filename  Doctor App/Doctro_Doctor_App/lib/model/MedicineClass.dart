class MedicineModel{

  String? _medName;
  String? _medDay;
  bool? _isMorning;
  bool? _isAfternoon;
  bool? _isNight;

  String? get medName => _medName;

  set medName(String? value) {
    _medName = value;
  }

  String? get medDay => _medDay;

  bool? get isNight => _isNight;

  set isNight(bool? value) {
    _isNight = value;
  }

  bool? get isAfternoon => _isAfternoon;

  set isAfternoon(bool? value) {
    _isAfternoon = value;
  }

  bool? get isMorning => _isMorning;

  set isMorning(bool? value) {
    _isMorning = value;
  }

  set medDay(String? value) {
    _medDay = value;
  }
}