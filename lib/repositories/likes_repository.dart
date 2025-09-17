import 'package:shared_preferences/shared_preferences.dart';

class LikesRepository {
  static const _key = 'liked_ids';

  // Charger les IDs likés
  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  // Sauvegarder les IDs likés
  Future<void> save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

}
