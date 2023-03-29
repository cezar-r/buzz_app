
import '../constants.dart';

class UserPreferencesController {

  static List<String> _preferences = [];

  UserPreferencesController();

  List<String> get preferences => _preferences;

  void addGenre(String genre) {
    _preferences.add(genre);
  }

  void removeGenre(String genre) {
    List<String> newPreferences = [];
    _preferences.remove(genre);
    for (String subGenre in _preferences) {
      if (!subGenre.startsWith(genre)) {
        newPreferences.add(subGenre);
      }
    }
    _preferences = newPreferences;
  }
}