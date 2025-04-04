import 'package:flutter/material.dart';
import 'package:untitled5/core/utils/assets.dart';
import '../../../../../constants.dart';
import '../../../../home/presentation/views/widgets/home_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      navigateTo(context, const HomeView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AssetsData.logo,
          width: 400,
          height: 400,
        ),
      ],
    );
  }
}
