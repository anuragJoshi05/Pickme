Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

// Ideal time to initialize
await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//...
}
