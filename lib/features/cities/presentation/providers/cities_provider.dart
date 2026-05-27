import 'package:flutter/foundation.dart';

import '../../data/mock_cities_data.dart';

/// Holds Cities-tab UI state: which sport / league chip is selected and
/// which page of the host-city carousel is in view.
class CitiesProvider extends ChangeNotifier {
  String _selectedSportId = kMockSports.first.id;
  String _selectedLeagueId = kMockLeagues.first.id;
  int _selectedCityIndex = 0;

  String get selectedSportId => _selectedSportId;
  String get selectedLeagueId => _selectedLeagueId;
  int get selectedCityIndex => _selectedCityIndex;

  void selectSport(String id) {
    if (_selectedSportId == id) return;
    _selectedSportId = id;
    notifyListeners();
  }

  void selectLeague(String id) {
    if (_selectedLeagueId == id) return;
    _selectedLeagueId = id;
    notifyListeners();
  }

  void selectCity(int index) {
    if (_selectedCityIndex == index) return;
    _selectedCityIndex = index;
    notifyListeners();
  }
}
