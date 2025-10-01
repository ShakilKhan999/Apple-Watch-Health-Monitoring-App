class ProfileSetupModel {
  String fullName;
  String dob;
  String gender;

  // Height
  bool isHeightInCm;
  String heightCm;
  String heightFt;
  String heightIn;

  // Weight
  bool isWeightInKg;
  String weightKg;
  String weightLbs;

  ProfileSetupModel({
    this.fullName = '',
    this.dob = '',
    this.gender = 'Male',
    this.isHeightInCm = false,
    this.heightCm = '',
    this.heightFt = '',
    this.heightIn = '',
    this.isWeightInKg = false,
    this.weightKg = '',
    this.weightLbs = '',
  });
}
