import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  String email = '';
  String password = '';
  bool isLoading = false;
  bool isCheckingEmail = false;
  bool isEmailChecked = false;
  bool isEmailAvailable = false;
  String emailError = '';
  final AuthService _authService = AuthService();

  Future<void> checkEmailDuplicate() async {
    if (email.isEmpty || isCheckingEmail) return;

    setState(() {
      isCheckingEmail = true;
      emailError = '';
    });

    try {
      final isDuplicate = await _authService.checkEmailDuplicate(email.trim());
      setState(() {
        isEmailChecked = true;
        isEmailAvailable = !isDuplicate;
        if (isDuplicate) {
          emailError = '중복된 이메일입니다.';
        }
      });
    } catch (e) {
      setState(() {
        emailError = '이메일 중복검사에 실패했습니다.';
      });
    } finally {
      setState(() {
        isCheckingEmail = false;
      });
    }
  }

  Future<void> handleSignup() async {
    if (!isEmailAvailable || password.isEmpty || isLoading) return;
    setState(() => isLoading = true);
    try {
      final response =
          await _authService.register(email: email.trim(), password: password);
      // 회원가입 성공 시 처리 (예: 다음 화면 이동)
      print('회원가입 성공: ${response.email}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );
      // TODO: 다음 화면으로 이동
    } catch (e) {
      print('회원가입 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이메일 입력 및 중복검사
            const Text(
              '이메일',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '이메일을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      setState(() {
                        email = v;
                        // 이메일이 변경되면 중복검사 상태 초기화
                        if (isEmailChecked) {
                          isEmailChecked = false;
                          isEmailAvailable = false;
                          emailError = '';
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: email.isEmpty || isCheckingEmail
                      ? null
                      : checkEmailDuplicate,
                  child: isCheckingEmail
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('중복검사'),
                ),
              ],
            ),

            // 이메일 상태 표시
            if (isEmailChecked) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isEmailAvailable ? Icons.check_circle : Icons.error,
                    color: isEmailAvailable ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isEmailAvailable ? '사용 가능한 이메일입니다.' : '중복된 이메일입니다.',
                    style: TextStyle(
                      color: isEmailAvailable ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],

            if (emailError.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                emailError,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],

            const SizedBox(height: 24),

            // 비밀번호 입력 (이메일 중복검사 완료 후에만 활성화)
            const Text(
              '비밀번호',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력하세요',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              enabled: isEmailAvailable, // 이메일 중복검사 완료 후에만 활성화
              onChanged: (v) => setState(() => password = v),
            ),

            const SizedBox(height: 24),

            // 회원가입 버튼 (이메일 중복검사 완료 후에만 활성화)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (isEmailAvailable && password.isNotEmpty && !isLoading)
                        ? handleSignup
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('회원가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
