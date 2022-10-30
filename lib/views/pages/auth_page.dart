import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/services/auth.dart';
import 'package:e_commerce_app/utilites/assets.dart';
import 'package:e_commerce_app/utilites/enums.dart';
import 'package:e_commerce_app/utilites/routes.dart';
import 'package:e_commerce_app/views/pages/landing_page.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:e_commerce_app/views/widgets/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_dialog.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthController model) async {
    try {
      await model.submit();
      if (!mounted) return;
      Navigator.of(context).pushNamed(AppRoutes.landingPageRoute);
    } catch (e) {
      MainDialog(context: context, title: 'Erorr', content: e.toString())
          .showAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<AuthController>(
      create: (_) => AuthController(auth: auth),
      child: Consumer<AuthController>(
        builder: (_, model, __) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 32,
                  right: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.authFormType == AuthFormType.login
                            ? 'Login'
                            : 'Register',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        onChanged: model.updateEmail,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                        validator: ((val) =>
                            val!.isEmpty ? 'Please enter your email' : null),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email !',
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        obscureText: true,
                        onChanged: model.updatePassword,
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        validator: ((val) =>
                            val!.isEmpty ? 'Please enter your password' : null),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your Password !',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (model.authFormType == AuthFormType.login)
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: const Text('Forgot your password?'),
                            onTap: () {},
                          ),
                        ),
                      const SizedBox(
                        height: 24,
                      ),
                      MainButton(
                          text: model.authFormType == AuthFormType.login
                              ? 'Login'
                              : 'Register',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _submit(model);
                            }
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Text(model.authFormType == AuthFormType.login
                              ? 'Don\'t have an account? Register'
                              : 'Have an account Login?'),
                          onTap: () {
                            _formKey.currentState!.reset();
                            model.toggleFormType();
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * .09,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            model.authFormType == AuthFormType.login
                                ? 'Or Login with '
                                : 'Or Register with',
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialMediaButton(
                              iconName: AppAssets.googleIcon, onPress: () {}),
                          const SizedBox(
                            width: 16,
                          ),
                          SocialMediaButton(
                              iconName: AppAssets.facebokeIcon, onPress: () {})
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
          );
        },
      ),
    );
  }
}
