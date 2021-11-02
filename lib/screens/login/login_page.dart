import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_test/screens/home/home_page.dart';
import 'package:mobx_test/screens/login/login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginStore loginStore = LoginStore();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool showPassword = true;

  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    reactionDisposer();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reactionDisposer = reaction((_) => loginStore.isLoggedIn, (bool loggedIn) {
      if (loggedIn) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: const Image(
                      image: NetworkImage(
                          "https://media-exp1.licdn.com/dms/image/C4D0BAQGdYK8RR6vNNQ/company-logo_200_200/0/1635273571803?e=1643846400&v=beta&t=nmJX5cAnUFGroSM48htTKZrHHddKvmA1VQ5_SpERLa8"),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Column(
                    children: [
                      Observer(builder: (_) {
                        return TextField(
                          enabled: !loginStore.loading,
                          onChanged: loginStore.setEmail,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          controller: _emailController,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person),
                              labelText: 'E-mail',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Observer(builder: (_) {
                        return TextField(
                          enabled: !loginStore.loading,
                          onChanged: loginStore.setPassword,
                          obscureText: loginStore.showPassword,
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: loginStore.toggleShowPassword,
                                  child: const Icon(
                                      Icons.remove_red_eye_outlined)),
                              labelText: 'Senha',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        );
                      })
                    ],
                  ),
                  const Spacer(),
                  Observer(builder: (context) {
                    return GestureDetector(
                      onTap: loginStore.login,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              loginStore.isFormValid ? Colors.blue : Colors.red,
                        ),
                        child: loginStore.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text('Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    );
                  }),
                  const Spacer(),
                ],
              ),
            ),
          )),
    );
  }
}
