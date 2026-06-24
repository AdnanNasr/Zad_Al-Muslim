import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/features/pray_time/domain/entities/user_address_entity.dart';

part 'user_address_model.g.dart';

@collection
class UserAddressModel {
  UserAddressModel({this.country, this.locality, this.countryCode});

  Id id = Isar.autoIncrement;

  final String? country;
  final String? locality;
  final String? countryCode;

  UserAddressEntity toEntity() {
    return UserAddressEntity(
      country: country ?? '',
      locality: locality ?? '',
      countryCode: countryCode ?? '',
    );
  }

  factory UserAddressModel.fromEntity(UserAddressEntity entity) {
    return UserAddressModel(
      country: entity.country,
      locality: entity.locality,
      countryCode: entity.countryCode,
    );
  }
}
