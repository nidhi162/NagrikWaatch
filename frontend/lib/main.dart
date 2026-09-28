import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NagrikWaatchApp());
}

// ============================================================
// APP
// ============================================================

class NagrikWaatchApp extends StatelessWidget {
  const NagrikWaatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NagrikWaatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff5f7fb),
      ),
      home: const LoginPage(),
    );
  }
}

// ============================================================
// API CONFIGURATION
// ============================================================

class ApiConfig {
  // Development:
  static const String baseUrl = 'http://localhost:5000';

  // Later, when backend is deployed publicly, replace the above with:
  // static const String baseUrl = 'https://your-backend-domain.com';

  static String get registerUrl => '$baseUrl/auth/register';
  static String get loginUrl => '$baseUrl/auth/login';
}

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter email and password.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      Map<String, dynamic> data = {};

      if (response.body.isNotEmpty) {
        data = jsonDecode(response.body);
      }

      if (!mounted) return;

      if (response.statusCode == 200) {
        final user = data['user'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(
              userName: user?['name'] ?? 'Citizen',
              userEmail: user?['email'] ?? email,
            ),
          ),
        );
      } else {
        showMessage(
          data['message'] ?? 'Invalid email or password.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      showMessage(
        'Unable to connect to NagrikWaatch server.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_balance,
                      size: 65,
                      color: Colors.indigo,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'NagrikWaatch',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Citizen Help & Grievance Platform',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginUser,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateAccountPage(),
                            ),
                          );
                        },
                        child: const Text('CREATE ACCOUNT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CREATE ACCOUNT
// ============================================================

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final localityController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool locationAdded = false;
  bool identityVerified = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    dobController.dispose();
    addressController.dispose();
    localityController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  Widget inputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMessage(
        'Name, email and password are required.',
      );
      return;
    }

    if (password.length < 6) {
      showMessage(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      Map<String, dynamic> data = {};

      if (response.body.isNotEmpty) {
        data = jsonDecode(response.body);
      }

      if (!mounted) return;

      if (response.statusCode == 201) {
        showMessage(
          'Account created successfully.',
        );

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(
              userName: name,
              userEmail: email,
            ),
          ),
          (route) => false,
        );
      } else {
        showMessage(
          data['message'] ?? 'Registration failed.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      showMessage(
        'Could not connect to the NagrikWaatch server.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 720,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Citizen Registration',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Create your NagrikWaatch citizen account.',
                    ),

                    const SizedBox(height: 25),

                    inputField(
                      'Full Name',
                      nameController,
                      Icons.person,
                    ),

                    inputField(
                      'Email',
                      emailController,
                      Icons.email,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),

                    inputField(
                      'Password',
                      passwordController,
                      Icons.lock,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),
                    ),

                    inputField(
                      'Phone Number',
                      phoneController,
                      Icons.phone,
                      keyboardType:
                          TextInputType.phone,
                    ),

                    inputField(
                      'Date of Birth',
                      dobController,
                      Icons.calendar_month,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Address Details',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    inputField(
                      'House / Street',
                      addressController,
                      Icons.home,
                    ),

                    inputField(
                      'Locality / Area',
                      localityController,
                      Icons.location_city,
                    ),

                    inputField(
                      'City',
                      cityController,
                      Icons.location_city,
                    ),

                    inputField(
                      'State / Region',
                      stateController,
                      Icons.map,
                    ),

                    inputField(
                      'PIN Code',
                      pincodeController,
                      Icons.pin_drop,
                      keyboardType:
                          TextInputType.number,
                    ),

                    const SizedBox(height: 5),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            locationAdded = true;
                          });
                        },
                        icon: Icon(
                          locationAdded
                              ? Icons.check_circle
                              : Icons.my_location,
                        ),
                        label: Text(
                          locationAdded
                              ? 'Location Added'
                              : 'Add Current Location',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            identityVerified = true;
                          });
                        },
                        icon: Icon(
                          identityVerified
                              ? Icons.verified
                              : Icons.security,
                        ),
                        label: Text(
                          identityVerified
                              ? 'Verification Selected'
                              : 'Verify Identity',
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : registerUser,
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'CREATE ACCOUNT',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FORGOT PASSWORD
// ============================================================

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendResetRequest() {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your registered email.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password reset service will be connected next.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 60,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: emailController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Registered Email',
                        prefixIcon:
                            Icon(Icons.email),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: sendResetRequest,
                        child: const Text(
                          'SEND RESET EMAIL',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardPage extends StatelessWidget {
  final String userName;
  final String userEmail;

  const DashboardPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  void openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NagrikWaatch'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, $userName',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Text(userEmail),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Citizen Support Services',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                GridView.count(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      MediaQuery.of(context).size.width >
                              800
                          ? 3
                          : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    serviceCard(
                      context,
                      'Report Problem',
                      Icons.report_problem,
                      'Report civic or public issues.',
                      const ReportProblemPage(),
                    ),

                    serviceCard(
                      context,
                      'Government Help',
                      Icons.account_balance,
                      'Connect with relevant government services.',
                      const GovernmentHelpPage(),
                    ),

                    serviceCard(
                      context,
                      'Education',
                      Icons.school,
                      'Scholarships and education support.',
                      const EducationPage(),
                    ),

                    serviceCard(
                      context,
                      'Tribal Support',
                      Icons.groups,
                      'Support and resources for tribal communities.',
                      const TribalSupportPage(),
                    ),

                    serviceCard(
                      context,
                      'Sports Support',
                      Icons.sports,
                      'Sports schemes and assistance.',
                      const SportsSupportPage(),
                    ),

                    serviceCard(
                      context,
                      'Health & Cancer',
                      Icons.local_hospital,
                      'Health and cancer assistance.',
                      const HealthSupportPage(),
                    ),

                    serviceCard(
                      context,
                      'Overseas Indian Help',
                      Icons.public,
                      'Support for Indians working abroad.',
                      const OverseasSupportPage(),
                    ),

                    serviceCard(
                      context,
                      'Teacher / Faculty',
                      Icons.person_pin,
                      'Education staff and faculty issues.',
                      const TeacherSupportPage(),
                    ),

                    serviceCard(
                      context,
                      'Emergency Help',
                      Icons.emergency,
                      'Flood, landslide and other emergencies.',
                      const EmergencyPage(),
                    ),

                    serviceCard(
                      context,
                      'Helpers & NGOs',
                      Icons.volunteer_activism,
                      'Register as a helper or organization.',
                      const HelperPage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    Widget page,
  ) {
    return Card(
      child: InkWell(
        onTap: () => openPage(context, page),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 38,
                color: Colors.indigo,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GENERIC SUPPORT PAGE
// ============================================================

class SupportListPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<String> services;

  const SupportListPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 850),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          size: 60,
                          color: Colors.indigo,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                ...services.map(
                  (service) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      title: Text(service),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              '$service service selected.',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SUPPORT PAGES
// ============================================================

class GovernmentHelpPage extends StatelessWidget {
  const GovernmentHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Government Help',
      description:
          'Find the appropriate public authority or department for your issue.',
      icon: Icons.account_balance,
      services: [
        'Flood and Disaster Management',
        'District Administration',
        'Municipal / Local Government',
        'Public Works and Roads',
        'Electricity Related Complaints',
        'Water and Sanitation',
        'Women and Child Support',
        'Social Welfare',
        'Labour and Employment',
        'Legal / Citizen Rights Support',
      ],
    );
  }
}

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Education Support',
      description:
          'Education assistance, scholarships and academic support.',
      icon: Icons.school,
      services: [
        'Government Scholarships',
        'Foreign Education Scholarships',
        'Study Abroad Assistance',
        'Financial Education Support',
        'College / University Issues',
        'Teacher / Faculty Issues',
        'Student Grievances',
        'Research and Fellowship Support',
      ],
    );
  }
}

class TribalSupportPage extends StatelessWidget {
  const TribalSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Tribal Support',
      description:
          'Support access for tribal communities and citizens.',
      icon: Icons.groups,
      services: [
        'Education Support',
        'Scholarship Assistance',
        'Community Development',
        'Livelihood Support',
        'Government Scheme Assistance',
        'Land / Documentation Support',
        'Healthcare Assistance',
        'Cultural and Community Support',
      ],
    );
  }
}

class SportsSupportPage extends StatelessWidget {
  const SportsSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Sports Support',
      description:
          'Connect athletes and sports communities with available support.',
      icon: Icons.sports,
      services: [
        'Sports Scholarship',
        'Athlete Financial Assistance',
        'Training Support',
        'Equipment Assistance',
        'Competition Support',
        'Sports Hostel / Facility Issues',
        'Coach / Faculty Issues',
        'National and International Opportunities',
      ],
    );
  }
}

class HealthSupportPage extends StatelessWidget {
  const HealthSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Health & Cancer Support',
      description:
          'Help citizens find appropriate healthcare and assistance resources.',
      icon: Icons.local_hospital,
      services: [
        'Government Health Schemes',
        'Cancer Treatment Assistance',
        'Financial Medical Support',
        'Hospital Related Grievance',
        'Blood / Donation Support',
        'Medicine Assistance',
        'Treatment Outside India',
        'Medical Documentation Support',
      ],
    );
  }
}

class OverseasSupportPage extends StatelessWidget {
  const OverseasSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Overseas Indian Support',
      description:
          'A support channel for Indian citizens working or studying abroad.',
      icon: Icons.public,
      services: [
        'Emergency Assistance Abroad',
        'Consular / Embassy Support',
        'Lost Documents',
        'Legal Assistance',
        'Employment Related Issues',
        'Student Abroad Support',
        'Emergency Family Communication',
        'Repatriation Assistance',
      ],
    );
  }
}

class TeacherSupportPage extends StatelessWidget {
  const TeacherSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Teacher / Faculty Support',
      description:
          'A dedicated channel for education staff and faculty issues.',
      icon: Icons.person_pin,
      services: [
        'Faculty Grievance',
        'Salary / Payment Issues',
        'Workplace Issues',
        'Student Safety Issues',
        'Institutional Complaints',
        'Academic Administration',
        'Research Support',
        'Professional Assistance',
      ],
    );
  }
}

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Emergency Assistance',
      description:
          'For urgent civic and disaster-related assistance.',
      icon: Icons.emergency,
      services: [
        'Flood',
        'Landslide',
        'Road Blockage',
        'Electricity Cable Fault',
        'Water Emergency',
        'Missing / Stranded Citizen',
        'Natural Disaster Assistance',
        'Emergency Help Request',
      ],
    );
  }
}

class HelperPage extends StatelessWidget {
  const HelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportListPage(
      title: 'Helpers, NGOs & Donors',
      description:
          'Organizations and individuals can register to support citizens.',
      icon: Icons.volunteer_activism,
      services: [
        'Register as a Volunteer',
        'Register NGO / Organization',
        'Community Helper',
        'Education Sponsor',
        'Medical Support Donor',
        'Cancer Support Donor',
        'Emergency Relief Support',
        'Scholarship Sponsor',
      ],
    );
  }
}

// ============================================================
// REPORT PROBLEM
// ============================================================

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() =>
      _ReportProblemPageState();
}

class _ReportProblemPageState
    extends State<ReportProblemPage> {
  final descriptionController =
      TextEditingController();

  String category = 'Other';

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void submitReport() {
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please describe the problem.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Report form submitted for processing.',
        ),
      ),
    );

    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Problem'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 750),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration:
                          const InputDecoration(
                        labelText: 'Problem Category',
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [
                        'Flood',
                        'Road',
                        'Electricity',
                        'Water',
                        'Education',
                        'Health',
                        'Other',
                      ]
                          .map(
                            (item) =>
                                DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            category = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller:
                          descriptionController,
                      maxLines: 7,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Describe your problem',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: submitReport,
                        icon: const Icon(Icons.send),
                        label: const Text(
                          'SUBMIT REPORT',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}