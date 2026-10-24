import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// إنشاء حساب جديد + حفظ البيانات في Firestore
  static Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String college,
    required String major,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'college': college.trim(),
        'major': major.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // نجح، مفيش خطأ
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      debugPrint('REGISTER ERROR: $e');
      return 'حصل خطأ غير متوقع، حاولي تاني';
    }
  }

  /// تسجيل دخول
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return 'حصل خطأ غير متوقع، حاولي تاني';
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// جلب بيانات المستخدم من Firestore
  static Future<Map<String, dynamic>?> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  static String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'البريد الإلكتروني ده مستخدم قبل كده';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني مش صح';
      case 'weak-password':
        return 'كلمة السر ضعيفة، لازم تكون 6 أحرف على الأقل';
      case 'user-not-found':
        return 'مفيش حساب بالبريد ده';
      case 'wrong-password':
      case 'invalid-credential':
        return 'كلمة السر غلط';
      default:
        return 'حصل خطأ، حاولي تاني';
    }
  }
}
