import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_cheker/bloc/auth_bloc.dart';
import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/spacing.dart';
import 'package:time_cheker/const/text_field.dart';
import 'package:time_cheker/screens/main/home_screen.dart';
import 'package:time_cheker/service/app/di.dart';
import 'package:time_cheker/service/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Repository _repository = instance<Repository>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscured = true;
  bool _isRegisterDevice = false;
  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final isRemembered = prefs.getBool('remember_me') ?? false;

    if (savedUsername != null && isRemembered) {
      setState(() {
        _usernameController.text = savedUsername;
        _isRegisterDevice = true;
      });
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showValidationDialog(
          'Уучлаарай', 'Нэвтрэх нэр болон нууц үг оруулна уу.');
      return;
    }

    try {
      final token = await _repository.login(username, password);
      final prefs = await SharedPreferences.getInstance();

      if (mounted) {
        if (token == 'DeviceNotFound') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Төхөөрөмж олдсонгүй.')),
          );
        } else if (token == 'InvalidCredentials') {
          _showValidationDialog(
              'Алдаа', 'Утасны дугаар болон нууц үг буруу байна.');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: successColor7,
              content: Text('Амжилттай нэвтэрлээ.',
                  style: ktsBodyMediumBold.copyWith(color: whiteColor)),
            ),
          );

          if (_isRegisterDevice) {
            await prefs.setString('saved_token', token);
            await prefs.setString('saved_username', username);
            await prefs.setBool('remember_me', true);
          } else {
            await prefs.remove('saved_username');
            await prefs.remove('saved_token');
            await prefs.setBool('remember_me', false);
          }

          context.read<AuthBloc>().add(LoggedIn(token: token));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: dangerColor7,
          content: Text('Та утасны дугаар болон нууц үгээ шалгана уу.',
              style: ktsBodyMediumBold.copyWith(color: whiteColor)),
        ),
      );
    }
  }

  void _showValidationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // AnimationController for controlling the animation
        AnimationController controller = AnimationController(
          duration: const Duration(milliseconds: 800), // Animation duration
          vsync:
              Navigator.of(context), // This provides the ticker for animation
        );

        // Scale animation, grows from 0.5x to 1.0x size
        Animation<double> scaleAnimation = CurvedAnimation(
          parent: controller,
          curve: Curves.elasticInOut, // Elastic effect curve for the animation
        );

        controller.forward(); // Start the animation

        return ScaleTransition(
          scale: scaleAnimation, // Apply the scale animation to the dialog
          child: AlertDialog(
            backgroundColor: Colors.white, // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0), // Rounded corners
            ),
            title: Row(
              children: [
                const Icon(Icons.error, color: dangerColor5), // Error icon
                const SizedBox(width: 10), // Space between icon and text
                Text(
                  title,
                  style: ktsBodyMassiveBold.copyWith(color: greyColor8),
                ),
              ],
            ),
            content: Text(
              message,
              style: ktsBodyMedium.copyWith(color: greyColor8),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'ОК',
                  style: ktsBodyLargeBold.copyWith(
                    color: informationColor7, // Custom button text color
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  controller.dispose(); // Dispose of the animation controller
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const SizedBox(height: 250),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Нэвтрэх',
                style: ktsBodyMassivePlusSemiBold.copyWith(color: greyColor8)),
            h8(),
            Text('Өөрийн мэдээллээ оруулна уу',
                style: ktsBodyMedium.copyWith(color: greyColor4)),
            const SizedBox(height: 20),
            _buildTextField(_usernameController, 'Нэвтрэх нэр', false),
            h8(),
            _buildTextField(_passwordController, 'Нууц үг', true),
            h8(),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      onSurface: Colors.red.shade200,
                      primary: informationColor9,
                    ),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isRegisterDevice = !_isRegisterDevice;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isRegisterDevice,
                      onChanged: (value) {
                        setState(() {
                          _isRegisterDevice = value ?? false;
                        });
                      },
                    ),
                    const Text('Төхөөрөмж хадгалах'),
                  ],
                ),
              ),
            ),
            h48(),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, bool isPassword) {
    return TextField(
      cursorColor: informationColor6,
      controller: controller,
      obscureText: isPassword ? _isObscured : false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: ktsBodyMedium.copyWith(color: greyColor4),
        filled: true,
        fillColor: greyColor1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon:
                    Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                color: greyColor5,
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity, // Дэлгэцийн өргөнийг ашиглах
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: informationColor8,
          padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text('Нэвтрэх',
            style: ktsBodyLargeBold.copyWith(color: whiteColor)),
      ),
    );
  }
}
