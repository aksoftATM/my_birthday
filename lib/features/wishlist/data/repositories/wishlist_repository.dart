import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/data/user_profile_repository.dart';
import '../models/wish_model.dart';

class WishlistRepository {
  static const _key = 'wishlist_items';
  final SharedPreferences _prefs;

  WishlistRepository(this._prefs);

  List<WishItem> getAll() {
    final json = _prefs.getString(_key);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list
        .map((e) => WishItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<WishItem> items) async {
    await _prefs.setString(
      _key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> add(WishItem item) async {
    final items = getAll();
    items.add(item);
    await _saveAll(items);
  }

  Future<void> update(WishItem item) async {
    final items = getAll();
    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveAll(items);
    }
  }

  Future<void> delete(String id) async {
    final items = getAll();
    items.removeWhere((e) => e.id == id);
    await _saveAll(items);
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(ref.watch(sharedPreferencesProvider));
});

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<WishItem>>((ref) {
  return WishlistNotifier(ref.watch(wishlistRepositoryProvider));
});

class WishlistNotifier extends StateNotifier<List<WishItem>> {
  final WishlistRepository _repo;

  WishlistNotifier(this._repo) : super([]) {
    state = _repo.getAll();
  }

  Future<void> add(String title, {String? url}) async {
    final item = WishItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      url: url,
      createdAt: DateTime.now(),
    );
    await _repo.add(item);
    state = _repo.getAll();
  }

  Future<void> togglePurchased(String id) async {
    final item = state.firstWhere((e) => e.id == id);
    await _repo.update(item.copyWith(isPurchased: !item.isPurchased));
    state = _repo.getAll();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = _repo.getAll();
  }

  Future<void> clear() async {
    await _repo.clear();
    state = [];
  }
}
