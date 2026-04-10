/// يحمل بيانات حساب القبلة المطلوبة للعرض
class QiblaEntity {
  /// زاوية اتجاه القبلة من الشمال الحقيقي (بالدرجات، 0–360)
  /// محسوبة بواسطة مكتبة adhan
  final double qiblaAngle;

  /// المسافة إلى الكعبة المشرفة بالكيلومترات
  final double distanceKm;

  const QiblaEntity({required this.qiblaAngle, required this.distanceKm});
}
