import 'package:flutter/material.dart';

// A mock class to store user information
class User {
  final String name;
  final String email;
  final String bio;

  User(this.name, this.email, this.bio);
}

// A mock function to simulate authentication
Future<User> authenticate(String email, String password) async {
  // Assume the email and password are valid
  await Future.delayed(Duration(seconds: 2)); // Simulate network delay
  return User('User', email, 'NewUU Student'); // Return a mock user
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework 3',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          User user = await authenticate(
                              _emailController.text, _passwordController.text);
                          setState(() {
                            _loading = false;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(user: user),
                            ),
                          );
                        }
                      },
                      child: Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEnglish ? 'Home Screen' : 'Bosh sahifa'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isEnglish
                      ? 'Welcome, ${widget.user.name}!'
                      : 'Xush kelibsiz, ${widget.user.name}!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          message: _isEnglish
                              ? 'This message is a received argument from homescreen!'
                              : 'Bu xabar bosh sahifadan qabul qilingan argument!',
                        ),
                      ),
                    );
                  },
                  child: Text(_isEnglish
                      ? 'Go to Detail Screen'
                      : 'Tafsilotlar sahifasiga o\'tish'),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isEnglish ? 'Settings' : 'Sozlamalar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEnglish = !_isEnglish;
                    });
                  },
                  child: Text(_isEnglish
                      ? 'Change Language to Uzbek'
                      : 'Tilni inglizchaga o\'zgartirish'),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isEnglish ? 'Profile' : 'Profil',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'),
                ),
                SizedBox(height: 16),
                Text(
                  widget.user.name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  widget.user.bio,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              Text(_isEnglish ? 'Confirmation' : 'Tasdiqlash'),
                          content: Text(_isEnglish
                              ? 'Do you want to logout?'
                              : 'Chiqmoqchimisiz?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child:
                                  Text(_isEnglish ? 'Cancel' : 'Bekor qilish'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text(_isEnglish ? 'Logout' : 'Chiqish'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(_isEnglish ? 'Logout' : 'Chiqish'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: _isEnglish ? 'Home' : 'Bosh sahifa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: _isEnglish ? 'Settings' : 'Sozlamalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: _isEnglish ? 'Profile' : 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String message;

  DetailScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Center(
        child: Text('Received data: $message'),
      ),
    );
  }
}
