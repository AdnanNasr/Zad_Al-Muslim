import 'package:isar/isar.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';

part 'user_address_model.g.dart';

@collection
class UserAddressModel {
  UserAddressModel({this.country, this.locality});
  Id id = Isar.autoIncrement;

  final String? country;
  final String? locality;

  UserAddressEntity toEntity() {
    return UserAddressEntity(
      country: country,
      locality: locality
    );
  }

  factory UserAddressModel.fromEntity(UserAddressModel entity){
    return UserAddressModel(country: entity.country, locality: entity.locality);
  }
}