import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:annapurna/providers/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:annapurna/core/routes/app_route_const.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUpUser() async {
    final auth = ref.read(authProvider.notifier);

    String res = await auth.signUp(
        userName: userNameController.text,
        email: emailController.text,
        password: passwordController.text);

    if (res != 'signup successful') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      return;
    }
    context.go('${RoutePath.tabs}/:${userNameController.text}');
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
        padding: EdgeInsets.all(60.r),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Text(
                  'Create account',
                  style: TextStyle(fontSize: 100.sp),
                ),

                // Sub-Heading
                Text(
                  'Create a new account',
                  style: TextStyle(fontSize: 40.sp),
                ),
                SizedBox(height: 20.h),

                // Username Text-box
                const Text('Username'),
                SizedBox(height: 4.h),
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(35.r),
                      child: Icon(Icons.person),
                    ),
                    hintText: 'Username',
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

                // Email text-box
                const Text('Email'),
                SizedBox(height: 4.h),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(35.r),
                      child: Icon(Icons.mail),
                    ),
                    hintText: 'Email',
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

                // Password text-box
                const Text('Password'),
                SizedBox(height: 4.h),
                TextField(
                  controller: passwordController,
                  obscureText: true,
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

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: signUpUser,
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
                            child: const Center(
                              child: Text('Sign up'),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                      ),
                      ElevatedButton(
                          onPressed: () {
                            context.go(RoutePath.login);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(0),
                              shadowColor: Colors.transparent),
                          child: Text('Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withGreen(160),
                                  )))
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
