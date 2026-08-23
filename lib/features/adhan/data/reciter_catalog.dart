import '../domain/reciter.dart';

/// The single Flutter source of truth for the bundled adhan pairs.
/// Keep each entry paired: a reciter is never allowed to fall back to another
/// reciter's Fajr asset.
abstract final class AdhanReciterCatalog {
  static const reciters = <AdhanReciter>[
    AdhanReciter(
      id: 'abdulbaset',
      name: 'عبد الباسط عبد الصمد',
      normalAsset: 'assets/sounds/abdulbaset.mp3',
      fajrAsset: 'assets/sounds/abdulbaset_fajr.mp3',
    ),
    AdhanReciter(
      id: 'alimulla',
      name: 'علي أحمد ملا',
      normalAsset: 'assets/sounds/alimulla.mp3',
      fajrAsset: 'assets/sounds/alimulla_fajr.mp3',
    ),
    AdhanReciter(
      id: 'alqatami',
      name: 'ناصر القطامي',
      normalAsset: 'assets/sounds/alqatami.mp3',
      fajrAsset: 'assets/sounds/alqatami_fajr.mp3',
    ),
    AdhanReciter(
      id: 'aserehy',
      name: 'عصام السرهِي',
      normalAsset: 'assets/sounds/aserehy.mp3',
      fajrAsset: 'assets/sounds/aserehy_fajr.mp3',
    ),
    AdhanReciter(
      id: 'joshar',
      name: 'أحمد جوهر',
      normalAsset: 'assets/sounds/joshar.mp3',
      fajrAsset: 'assets/sounds/joshar_fajr.mp3',
    ),
    AdhanReciter(
      id: 'kefah',
      name: 'كفاح العزاوي',
      normalAsset: 'assets/sounds/kefah.mp3',
      fajrAsset: 'assets/sounds/kefah_fajr.mp3',
    ),
    AdhanReciter(
      id: 'riad',
      name: 'رياض النقشبندي',
      normalAsset: 'assets/sounds/riad.mp3',
      fajrAsset: 'assets/sounds/riad_fajr.mp3',
    ),
  ];

  static const defaultId = 'abdulbaset';

  static AdhanReciter byId(String? id) => reciters.firstWhere(
    (reciter) => reciter.id == id,
    orElse: () => reciters.first,
  );
}
