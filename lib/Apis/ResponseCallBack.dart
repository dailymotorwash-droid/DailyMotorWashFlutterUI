
abstract class ResponseCallBack<T> {
  void onResponse(T response);
  void onFailure(Exception t);
}