import 'package:furniy_ar/controller/authenticationController.dart';
import 'package:furniy_ar/utils/app_size.dart';
import 'package:furniy_ar/utils/colors.dart';
import 'package:furniy_ar/view/admin/dashboard_screen.dart';
import 'package:furniy_ar/view/onboarding_screen.dart';
import 'package:furniy_ar/view/seller/root_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Function to navigate to the onboarding screen
    void navigateToOnboardingScreen() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }

    // Function to navigate to the appropriate screen based on user type
    void navigateBasedOnUserType(UserType userType) {
      if (userType == UserType.Admin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  const DashboardScreen() // Replace with your AdminRootPage widget
              ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RootPage(),
          ),
        );
      }
    }

    // Use a Future.delayed to wait for 3 seconds before checking user login status
    Future.delayed(
      const Duration(seconds: 4),
      () async {
        UserType userType = await AuthController().isUserLoggedIn();
        if (userType != UserType.None) {
          navigateBasedOnUserType(userType);
        } else {
          navigateToOnboardingScreen();
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(220),
              topLeft: Radius.circular(220),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: context.screenHeight * 0.77,
                child: Lottie.asset('assets/splash-icon.json'),
              ),
              const SizedBox(height: 5),
              const Text(
                'AR FurniFy System',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
