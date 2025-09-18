import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool rememberMe = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username and password",
          backgroundColor: Colors.red.shade100);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.post('/login', {
        "username": username,
        "password": password,
      });

      final data = response.data;

      if (data['status'] == true && data['token'] != null) {
        await ApiService.saveToken(data['token']);
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar("Login Failed", data['message'] ?? "Something went wrong",);
           
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      print("Login Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
    Color(0xFF4CAF50), // Green 500 (standard green)
    Color(0xFF388E3C), // Green 700 (darker green)
  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            /// LOGIN CARD
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Login",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),

                    /// Username Field
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Password Field
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    /// Forgot Password
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: TextButton(
                    //     onPressed: () {
                    //       // Get.to(() => TroubleLoginScreen());
                    //     },
                    //     child: const Text(
                    //       "Forgot Password?",
                    //       style: TextStyle(color: Colors.green, fontSize: 13),
                    //     ),
                    //   ),
                    // ),

                    /// Remember Me
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            setState(() {
                              rememberMe = val ?? false;
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// LOGIN BUTTON
                   SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.green, // ✅ Solid green button
    ),
    onPressed: isLoading ? null : loginUser,
    child: isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : const Text(
            "LOGIN",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
  ),
),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // const Text("Or login with",
            //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            // const SizedBox(height: 15),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     socialButton("G", Colors.red),
            //     const SizedBox(width: 15),
            //     socialButton("f", Colors.blue),
            //     const SizedBox(width: 15),
            //     socialButton("X", Colors.black),
            //     const SizedBox(width: 15),
            //     socialButton("in", Colors.blueAccent),
            //   ],
            // ),

            const SizedBox(height: 25),

            // RichText(
            //   text: const TextSpan(
            //     text: "New user? ",
            //     style: TextStyle(color: Colors.black54, fontSize: 14),
            //     children: [
            //       TextSpan(
            //         text: "Signup",
            //         style: TextStyle(
            //           color: Colors.green,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 14,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Social login button UI
  Widget socialButton(String label, Color color) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: color.withOpacity(0.1),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
