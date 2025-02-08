import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefStorage{

  void setData(String token,String name,String email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
    preferences.setString('email', email);
    preferences.setString('token', token);
  }

  Future<String>getToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token') ?? "";
  }

  Future<List<String?>>getData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data = [];
    data.add(preferences.getString('name') ?? '');
    data.add(preferences.getString('email') ?? '');
    return data;
  }

 Future<void >removeToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    await preferences.remove('name');
    await preferences.remove('email');
    return;
  }
}