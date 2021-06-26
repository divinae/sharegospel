import 'package:hive/hive.dart';

part 'personal_shares.g.dart';

@HiveType(typeId: 1)
class PersonalShares extends HiveObject {
  @HiveField(0)
  Map<String, int> shares;

  @HiveField(1)
  Map<String, int> saved;
}
