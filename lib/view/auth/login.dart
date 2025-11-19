import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:annapurna/providers/auth_controller.dart';
import 'package:annapurna/core/routes/app_route_const.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    final auth = ref.read(authProvider.notifier);
    final FirebaseFirestore core = FirebaseFirestore.instance;

    // Attempt login
    var res = await auth.loginUser(
        email: emailController.text, password: passwordController.text);

    if (res != 'login successful') {
      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      return;
    }

    try {
      // Fetch the username from Firestore
      String userId = auth.auth.currentUser!.uid; // Get the current user's UID
      DocumentSnapshot userDoc =
          await core.collection('user').doc(userId).get();

      // Check if the document exists and retrieve the username
      if (userDoc.exists) {
        String userName = userDoc.get('username'); // Fetch the 'username' field

        // Navigate to the tabs screen with the username
        context.go('${RoutePath.tabs}/$userName');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')));
      }
    } catch (e) {
      // Handle errors, e.g., Firestore connection issues
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(65.r),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 90.sp),
                ),

                // Sub-Heading
                Text('Login to your account',
                    style: TextStyle(fontSize: 35.sp)),
                SizedBox(height: 15.h),

                // Username Text-box
                Text('Username / Email', style: TextStyle(fontSize: 45.sp)),
                SizedBox(height: 1.5.h),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(30.r),
                      child: Icon(Icons.person),
                    ),
                    hintText: 'Username / Email',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(63, 0, 0, 0), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(63, 0, 0, 0), width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Password text-box
                Text('Password', style: TextStyle(fontSize: 45.sp)),
                SizedBox(height: 1.5.h),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(35.r),
                      child: Icon(Icons.lock_open_sharp),
                    ),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35.r)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(63, 0, 0, 0), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35.r)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(63, 0, 0, 0), width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: loginUser,
                    focusColor: Theme.of(context).colorScheme.primary,
                    highlightColor: Theme.of(context).colorScheme.primary,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.r),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            width: double.infinity,
                            height: 25.h,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(35.r)),
                            child: Center(
                              child: Text('Login',
                                  style: TextStyle(fontSize: 42.sp)),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      ElevatedButton(
                        onPressed: () {
                          context.go(RoutePath.signup);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(0),
                            shadowColor: Colors.transparent),
                        child: Text(
                          'Signup',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withGreen(160),
                                  ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
