
String generatePatientCode(String fullName) {
  final initials = fullName
      .trim()
      .split(RegExp(r'\s+'))
      .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
      .join();

  // Obter data e hora atual
  final now = DateTime.now();
  final timestamp = '${now.year}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}'
      '${now.hour.toString().padLeft(2, '0')}'
      '${now.minute.toString().padLeft(2, '0')}'
      '${now.second.toString().padLeft(2, '0')}';
  
  final code = '$initials$timestamp'; 

  return code;
}