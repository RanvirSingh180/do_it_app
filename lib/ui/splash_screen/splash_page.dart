import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/utils/fonts.dart';
import '../../theme_provider.dart';
import '../page_view.dart';
import 'package:to_do_list/utils/images.dart';
import 'package:to_do_list/utils/strings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    checkTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Theme.of(context).backgroundColor,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(logo,
                color: Theme.of(context).primaryColor, height: 100, width: 100),
            const SizedBox(height: 30),
             Text(logoName,
                style: TextStyle(
                    fontSize: 40, color:Theme.of(context).primaryColor, fontFamily: comfortaa))
          ],
        ),
        splashIconSize: double.infinity,
        nextScreen: const Pages());
  }

  void checkTheme() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isDarkMode = sharedPreferences.getBool(preferenceKey) ?? false;
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(isDarkMode);
  }
}
