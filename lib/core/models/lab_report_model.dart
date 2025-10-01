class LabReportModel {
  final String id;
  final String title;
  final String filename;
  final int sizeInBytes;
  final DateTime uploadedAt;
  final String filePath;
  final String extension; // pdf / jpg etc.

  LabReportModel({
    required this.id,
    required this.title,
    required this.filename,
    required this.sizeInBytes,
    required this.uploadedAt,
    required this.filePath,
    required this.extension,
  });


 
}
