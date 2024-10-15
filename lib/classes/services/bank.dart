abstract class ApiService<T> {
  Future<List<T>> fetchAll();
  Future<T> fetchById(int id);
  Future<T> create(T data);
  Future<T> update(int id, T data);
  Future<void> delete(int id);
}
