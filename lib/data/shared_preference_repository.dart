import 'package:shared_preferences/shared_preferences.dart';
import 'database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static const String checklistKey = 'checklist';
  static const String doneKey = 'doneCounter';
  static const String deleteKey = 'deleteCounter';

  late final SharedPreferences _data;

  // Private Konstruktor
  SharedPreferencesRepository._internal(this._data);

  /// Initialisiert SharedPreferences vor der Nutzung
  static Future<SharedPreferencesRepository> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesRepository._internal(prefs);
  }

  /// Speichert die gesamte Checkliste
  Future<void> saveChecklist(List<String> items) async {
    await _data.setStringList(checklistKey, items);
  }

  /// Lädt die gesamte Checkliste
  Future<List<String>> loadChecklist() async {
    return _data.getStringList(checklistKey) ?? [];
  }

  /// Löscht die gesamte Checkliste
  Future<void> clearChecklist() async {
    await _data.remove(checklistKey);
  }

  // Zähler hochzählen
  Future<void> incrementCounter(String key) async {
    if (key == doneKey || key == deleteKey) {
      final current = _data.getInt(key) ?? 0;
      await _data.setInt(key, current + 1);
    }
  }

  // Zähler auslesen
  Future<int> getCounter(String key) async {
    if (key == doneKey || key == deleteKey) {
      return _data.getInt(key) ?? 0;
    } else {
      return 0;
    }
  }

  // Zähler löschen
  Future<void> clearCounter(String key) async {
    if (key == doneKey || key == deleteKey) {
      await _data.remove(key);
    }
  }

  @override
  Future<void> addItem(String item) async {
    final items = _data.getStringList(checklistKey) ?? [];
    items.add(item);
    await saveChecklist(items);
  }

  @override
  Future<void> deleteItem(int index) async {
    final items = _data.getStringList(checklistKey) ?? [];
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await saveChecklist(items);
    }
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    final items = _data.getStringList(checklistKey) ?? [];
    if (index >= 0 && index < items.length) {
      items[index] = newItem;
      await saveChecklist(items);
    }
  }

  @override
  Future<int> getItemCount() async {
    return _data.getStringList(checklistKey)?.length ?? 0;
  }

  @override
  Future<List<String>> getItems() async {
    return _data.getStringList(checklistKey) ?? [];
  }
}
