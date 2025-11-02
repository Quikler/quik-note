abstract class CacheService<K, V> {
  V? get(K key);
  void set(K key, V value);
  void remove(K key);
  bool has(K key);
  void clear();
  Map<K, V> getAll();
}

class InMemoryCacheService<K, V> implements CacheService<K, V> {
  final Map<K, V> _cache = {};
  @override
  V? get(K key) => _cache[key];
  @override
  void set(K key, V value) => _cache[key] = value;
  @override
  void remove(K key) => _cache.remove(key);
  @override
  bool has(K key) => _cache.containsKey(key);
  @override
  void clear() => _cache.clear();
  @override
  Map<K, V> getAll() => Map.unmodifiable(_cache);
}
