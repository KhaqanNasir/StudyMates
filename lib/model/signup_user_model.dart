class SignUpUser {
  final String uniqueId;
  final String fullName;
  final String email;
  final String department;
  final String password;
  final String ipAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  SignUpUser({
    required this.uniqueId,
    required this.fullName,
    required this.email,
    required this.department,
    required this.password,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'uniqueId': uniqueId,
      'fullName': fullName,
      'email': email,
      'department': department,
      'ipAddress': ipAddress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}