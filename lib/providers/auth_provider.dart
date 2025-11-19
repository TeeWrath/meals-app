import 'package:annapurna/core/utils/enums.dart';
import 'package:annapurna/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthController extends StateNotifier<bool> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController() : super(false) {
    checkAuthStatus();
  }

  Stream<User?> get authStateChanges => auth.authStateChanges();

  // getter and setters for user Id
  bool get isLoading => state;
  String _userId = "";
  String get userId => _userId;
  late bool isAuthenticated;
  UserModel _user = UserModel();
  UserModel get user => _user;

  void setLoading(bool load) {
    state = load;
  }

  void checkAuthStatus() {
    isAuthenticated = auth.currentUser != null;
    print("Auth status: $isAuthenticated");
    if (isAuthenticated == true) {
      setUser();
    }
  }

  void setUser() async {
    var userId = auth.currentUser?.uid;
    String userName = "";
    DocumentSnapshot doc =
        await _firestore.collection('user').doc(userId).get();
    if (doc.exists) {
      userName = doc.get('username');
      print("Username fetched: $userName");
    }

    _user = UserModel(userName: userName, email: auth.currentUser!.email!);
  }

  // setter function for user Id
  void _setUserId(String id) {
    _userId = id;
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required String userName}) async {
    setLoading(true);
    String res = 'some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Saves user Id
        _setUserId(cred.user!.uid);

        // saves other details of the user
        await _firestore
            .collection('user')
            .doc(cred.user!.uid)
            .set({'email': email, 'password': password, 'username': userName});
        setUser();
        res = 'signup successful';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      } else if (err.code == 'weak-password') {
        res = 'The password should be at least 6 characters';
      }
    } finally {
      setLoading(false);
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    setLoading(true);
    String res = 'some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      setUser();
      res = 'login successful';
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = 'User not found for this email';
      } else if (err.code == 'wrong-password') {
        res = 'Entered password is wrong';
      }
    } catch (e) {
      res = e.toString();
    } finally {
      setLoading(false);
    }
    return res;
  }

  void logOut() async {
    await auth.signOut();
  }
}

final authProvider = Provider<AuthController>((ref) {
  return AuthController();
});

final authStateProvider = StreamProvider<User?>(
  (ref) {
    return ref.watch(authProvider).authStateChanges;
  },
);

final authStatusProvider = Provider<AuthStatus>(
  (ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return AuthStatus.authenticated;
        } else {
          return AuthStatus.unauthenticated;
        }
      },
      error: (error, stackTrace) => AuthStatus.unauthenticated,
      loading: () => AuthStatus.unknown,
    );
  },
);
