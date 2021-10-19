
abstract class LogStrategy{
  const LogStrategy();
  ///输出参数，提供打印
  void debugInfo(Map<String,String> debugMapInfo);
}

///默认提供的打印参数等结果
class DefaultLogStrategy extends LogStrategy{

  @override
  void debugInfo(Map<String, String> debugMapInfo) {
    print('debugLog --->${debugMapInfo.toString()}');
  }

}