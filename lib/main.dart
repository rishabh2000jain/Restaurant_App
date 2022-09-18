import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_states.dart';
import 'package:restaurant_app/app/ui/restaurant_menu/restaurant_menu_screen.dart';
import 'package:restaurant_app/resources/colors.dart';
import 'package:restaurant_app/resources/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.kAppName,
      theme: ThemeData(
        backgroundColor: secondaryColor,
        primaryColor: primaryColor,
        chipTheme: ChipThemeData(backgroundColor: chipColor),
        colorScheme: ThemeData.light()
            .colorScheme
            .copyWith(tertiary: tertiaryColor,
          secondary: secondaryColor,
          inversePrimary: chipColor,
        ),
      ),
      home: BlocProvider(
        create: (BuildContext context) => RestaurantMenuBloc(
          const RestaurantMenuInitialState.completed(null),
        ),
        child: const RestaurantMenuScreen(),
      ),
    );
  }
}
