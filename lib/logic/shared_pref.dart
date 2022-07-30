import 'package:shared_preferences/shared_preferences.dart';
import 'mysql.dart';

class SharedPref {
  // 端末保存用のログイン中のユーザーid
  static final currentUserId = "";

  // 端末保存用のログイン中のユーザー名
  final currentUsername = "";

  // Shared_preference
  late SharedPreferences prefs;

  // MySQLクラスのインスタンス
  final MySQL _mysql = MySQL();

  // Shared_preferenceのインスタンスをセットするメソッド
  Future<void> setPrefInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Shared_preferenceに保存するメソッド
  Future<void> setPrefUserData(userList) async {
    await prefs.setString('userId', userList[0]);
    await prefs.setString('username',userList[1]);
  }

  // Shared_preferenceから値を取得するメソッド
  Future<String> getUserIdFromPref() async{
    return Future.value(prefs.getString('userId')!);
  }

  // Shared_preferenceから値を取得するメソッド
  Future<String> getUsernameFromPref() {
    return Future.value(prefs.getString('username')!);
  }
}
