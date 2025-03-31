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

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final Repository _repository = instance<Repository>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscured = true;
  bool _isRegisterDevice = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _repository.login(username, password);
      final prefs = await SharedPreferences.getInstance();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (token == 'DeviceNotFound') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: dangerColor5,
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: whiteColor),
                  const SizedBox(width: 10),
                  Text('Төхөөрөмж олдсонгүй',
                      style: ktsBodyMediumBold.copyWith(color: whiteColor)),
                ],
              ),
            ),
          );
        } else if (token == 'InvalidCredentials') {
          _showValidationDialog(
              'Алдаа', 'Нэвтрэх нэр эсвэл нууц үг буруу байна.');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: successColor7,
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: whiteColor),
                  const SizedBox(width: 10),
                  Text('Амжилттай нэвтэрлээ',
                      style: ktsBodyMediumBold.copyWith(color: whiteColor)),
                ],
              ),
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

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: dangerColor7,
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: whiteColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Нэвтрэх үйлдэл амжилтгүй боллоо. Дахин оролдоно уу.',
                    style: ktsBodyMediumBold.copyWith(color: whiteColor)),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showValidationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AnimationController controller = AnimationController(
          duration: const Duration(milliseconds: 800),
          vsync: Navigator.of(context),
        );

        Animation<double> scaleAnimation = CurvedAnimation(
          parent: controller,
          curve: Curves.elasticInOut,
        );

        controller.forward();

        return ScaleTransition(
          scale: scaleAnimation,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            title: Row(
              children: [
                const Icon(Icons.error, color: dangerColor5),
                const SizedBox(width: 10),
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
                    color: informationColor7,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.dispose();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              informationColor6.withOpacity(0.8),
              informationColor9,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  _buildLogo(),
                  const SizedBox(height: 40),
                  _buildLoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.access_time,
              size: 70,
              color: informationColor8,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Ирц бүртгэлийн систем",
            style: ktsBodyMassiveBold.copyWith(
              color: whiteColor,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Ахан дүүсийн ирц хяналтын систем",
            style: ktsBodyRegular.copyWith(color: whiteColor.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Нэвтрэх',
                style: ktsBodyMassivePlusSemiBold.copyWith(color: greyColor8),
              ),
              h8(),
              Text(
                'Өөрийн мэдээллээ оруулна уу',
                style: ktsBodyMedium.copyWith(color: greyColor4),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                  _usernameController, 'Нэвтрэх нэр', Icons.person, false),
              const SizedBox(height: n16),
              _buildTextField(_passwordController, 'Нууц үг', Icons.lock, true),
              const SizedBox(height: n16),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isRegisterDevice = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Төхөөрөмж хадгалах',
                        style: ktsBodyRegular.copyWith(color: greyColor7),
                      ),
                    ],
                  ),
                ),
              ),
              h24(),
              _buildLoginButton(),
              const SizedBox(height: n16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Forgot password action
                  },
                  child: Text(
                    'Нууц үгээ мартсан уу?',
                    style: ktsBodyRegular.copyWith(color: informationColor7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      IconData icon, bool isPassword) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        cursorColor: informationColor6,
        controller: controller,
        obscureText: isPassword ? _isObscured : false,
        style: ktsBodyMedium.copyWith(color: greyColor8),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: informationColor6),
          hintText: hintText,
          hintStyle: ktsBodyMedium.copyWith(color: greyColor4),
          filled: true,
          fillColor: greyColor1,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: informationColor6, width: 1.5),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: greyColor5,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: informationColor8,
          disabledBackgroundColor: informationColor8.withOpacity(0.6),
          elevation: 2,
          shadowColor: informationColor8.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: whiteColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Нэвтрэх',
                style: ktsBodyLargeBold.copyWith(color: whiteColor),
              ),
      ),
    );
  }
}
