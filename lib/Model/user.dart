enum Uses {
  ojt,
  training,
  getCheque,
  useOfEquipment,
  onlineClass,
  internet,
  print,
  encode,
  inquire,
  workimmersion,
  other,
}

class User {
  User({
    required this.brgy,
    required this.contact,
    required this.use,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.duplicate,
    String? id,
  }) : id = id ?? DateTime.now().toString();
  final int? age;
  final String fullName, brgy, contact, gender, use;
  //final Uses use;
  final String id;
  final int duplicate;

  /// TRIAL
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'contact_number': contact,
      'barangay': brgy,
      'gender': gender,
      'age': age,
      'purpose': use,
      'duplicate': duplicate,
    };
  }
}
