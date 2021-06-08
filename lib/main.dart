import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sample/screens/home_screen.dart';

final sharedProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());
final prefsProvider = Provider((ref) => PrefsShare(ref.watch(sharedProvider)));
class PrefsShare{
  SharedPreferences sharedPreferences;
  PrefsShare(this.sharedPreferences);


  bool isVisible(String id){
    return sharedPreferences.getBool(id)?? false;
  }

  Future<bool> setVal(bool val, String id) async{
    return await sharedPreferences.setBool(id, val);
  }

}

final statusProvider = StateNotifierProvider.family<StatusNotifier, bool, String>((ref,id) {
  final isVisible = ref.read(prefsProvider).isVisible(id);
  return StatusNotifier(isVisible, id);
});


class StatusNotifier extends StateNotifier<bool>{
  StatusNotifier(this.visibleMode, this.id) : super(visibleMode);
  final bool visibleMode;
  final String id;

   toggle(BuildContext context,String id){
    final isVisible = context.read(prefsProvider).isVisible(id);
    final toggleVal = !isVisible;

    context.read(prefsProvider).setVal(toggleVal, id).whenComplete(() => state = toggleVal);

  }


}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
    )
  );
  final shared = await SharedPreferences.getInstance();
  runApp(ProviderScope(
      overrides: [
        sharedProvider.overrideWithValue(shared),
      ],
      child: Home()));
}
class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey,
          primarySwatch: Colors.grey,
            errorColor: Colors.grey
        ),
        home: HomeScreen()
    );
  }
}
