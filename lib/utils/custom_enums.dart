enum VehicleType {
  all("ALL"),
  car("CAR"),
  twoWheeler("TWO_WHEELER");

  final String label;
  const VehicleType(this.label);
}
enum ProfileStatus{

  pending("PENDING"),
  completed("COMPLETED");

  final String label;
  const ProfileStatus(this.label);
}
enum ColorTheme {
  dark,
  light
}