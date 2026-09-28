import 'package:flutter/material.dart';

void main() {
  runApp(const NagrikWatchApp());
}

// ============================================================
// APP
// ============================================================

class NagrikWatchApp extends StatelessWidget {
  const NagrikWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NagrikWaatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
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

  void login() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: [
                const Icon(Icons.location_city, size: 80, color: Colors.blue),

                const SizedBox(height: 20),

                const Text(
                  'NagrikWaatch',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Smart Citizen Civic Reporting',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text('LOGIN'),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountPage(),
                      ),
                    );
                  },
                  child: const Text('Create New Account'),
                ),

                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset will be added next.'),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
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
  final addressController = TextEditingController();

  void createAccount() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name, email and password are required')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: createAccount,
                    child: const Text('CREATE ACCOUNT'),
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
// DASHBOARD
// ============================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    ReportPage(),
    MyReportsPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NagrikWaatch'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.report_problem_outlined),
            selectedIcon: Icon(Icons.report_problem),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome 👋',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            'Help make your city better.',
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 25),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Icon(Icons.campaign, size: 60, color: Colors.blue),

                  const SizedBox(height: 15),

                  const Text(
                    'Report a Civic Problem',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Report roads, garbage, water, electricity '
                    'and other civic issues.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Report Problem'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.support_agent)),
              title: const Text('Help Desk'),
              subtitle: const Text('Get help with your complaints.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpDeskPage()),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.emergency)),
              title: const Text('Emergency Help'),
              subtitle: const Text(
                'Flood, road blockage, electricity fault etc.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmergencyHelpPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REPORT PAGE
// ============================================================

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Roads';

  final categories = [
    'Roads',
    'Garbage',
    'Water',
    'Electricity',
    'Drainage',
    'Other',
  ];

  void submitReport() {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint submitted successfully!')),
    );

    titleController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Report Problem',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text('Tell us about a civic issue in your area.'),

          const SizedBox(height: 25),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Problem Title',
              hintText: 'Example: Broken road',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            items: categories.map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCategory = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe the problem...',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Google Maps location will be connected next.'),
                ),
              );
            },
            icon: const Icon(Icons.location_on),
            label: const Text('Add Location'),
          ),

          const SizedBox(height: 15),

          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image upload will be connected next.'),
                ),
              );
            },
            icon: const Icon(Icons.image),
            label: const Text('Add Photo'),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: submitReport,
              icon: const Icon(Icons.send),
              label: const Text('SUBMIT COMPLAINT'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MY REPORTS
// ============================================================

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Reports',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text('Track all the complaints you have submitted.'),

        const SizedBox(height: 25),

        ReportCard(
          reportId: 'NW-0001',
          title: 'Broken Road',
          category: 'Roads',
          status: 'Pending',
          statusColor: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportDetailsPage(),
              ),
            );
          },
        ),

        const SizedBox(height: 15),

        ReportCard(
          reportId: 'NW-0002',
          title: 'Garbage Not Collected',
          category: 'Garbage',
          status: 'Under Review',
          statusColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportDetailsPage(
                  reportTitle: 'Garbage Not Collected',
                  reportId: 'NW-0002',
                  category: 'Garbage',
                  status: 'Under Review',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// REPORT CARD
// ============================================================

class ReportCard extends StatelessWidget {
  final String reportId;
  final String title;
  final String category;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.reportId,
    required this.title,
    required this.category,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.report_problem)),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),

              const SizedBox(height: 15),

              Text('Report ID: $reportId'),

              const SizedBox(height: 5),

              Text('Category: $category'),

              const SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REPORT DETAILS PAGE
// ============================================================

class ReportDetailsPage extends StatelessWidget {
  final String reportTitle;
  final String reportId;
  final String category;
  final String status;

  const ReportDetailsPage({
    super.key,
    this.reportTitle = 'Broken Road',
    this.reportId = 'NW-0001',
    this.category = 'Roads',
    this.status = 'Pending',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- REPORT HEADER ----------------

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.report_problem, size: 28),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            reportTitle,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Report ID',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      reportId,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _InfoItem(
                            title: 'Category',
                            value: category,
                            icon: Icons.category,
                          ),
                        ),

                        Expanded(
                          child: _InfoItem(
                            title: 'Status',
                            value: status,
                            icon: Icons.pending_actions,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- DESCRIPTION ----------------
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'The road in this area is damaged and '
                  'has several potholes. It may cause '
                  'difficulty for vehicles and pedestrians.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- LOCATION ----------------
            const Text(
              'Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.withOpacity(0.08),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        'Google Maps location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text('Map will be connected next'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- STATUS TIMELINE ----------------
            const Text(
              'Report Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            const StatusTimelineItem(
              title: 'Report Submitted',
              date: '15 September 2026',
              description: 'Your complaint has been successfully submitted.',
              completed: true,
            ),

            const StatusTimelineItem(
              title: 'Under Review',
              date: 'Pending',
              description:
                  'The concerned department will review your complaint.',
              completed: false,
            ),

            const StatusTimelineItem(
              title: 'Work in Progress',
              date: 'Pending',
              description: 'Action will be taken after verification.',
              completed: false,
            ),

            const StatusTimelineItem(
              title: 'Resolved',
              date: 'Pending',
              description:
                  'The issue will be marked resolved after completion.',
              completed: false,
            ),

            const SizedBox(height: 25),

            // ---------------- SHARE ----------------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share Report feature will be added next.'),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('SHARE REPORT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO ITEM
// ============================================================

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.blue),

        const SizedBox(width: 8),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// STATUS TIMELINE ITEM
// ============================================================

class StatusTimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final bool completed;

  const StatusTimelineItem({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: completed
                    ? Colors.green
                    : Colors.grey.shade300,
                child: Icon(
                  completed ? Icons.check : Icons.circle,
                  size: completed ? 16 : 8,
                  color: completed ? Colors.white : Colors.grey,
                ),
              ),

              Expanded(
                child: Container(
                  width: 2,
                  color: completed ? Colors.green : Colors.grey.shade300,
                ),
              ),
            ],
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    date,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMERGENCY HELP
// ============================================================

class EmergencyHelpPage extends StatelessWidget {
  const EmergencyHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Help')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Emergency Assistance',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text('Quickly request help for urgent civic situations.'),

          const SizedBox(height: 25),

          EmergencyCard(
            icon: Icons.water,
            title: 'Flood',
            description: 'Request assistance during flooding.',
          ),

          EmergencyCard(
            icon: Icons.landslide,
            title: 'Landslide',
            description: 'Report a landslide or blocked area.',
          ),

          EmergencyCard(
            icon: Icons.block,
            title: 'Road Blockage',
            description: 'Report a blocked road or passage.',
          ),

          EmergencyCard(
            icon: Icons.electrical_services,
            title: 'Electricity Cable Fault',
            description: 'Report a dangerous cable fault.',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMERGENCY CARD
// ============================================================

class EmergencyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EmergencyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(radius: 25, child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title emergency request will be connected next.'),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// HELP DESK
// ============================================================

class HelpDeskPage extends StatelessWidget {
  const HelpDeskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Desk')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.support_agent, size: 80, color: Colors.blue),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'How can we help you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat Support'),
              subtitle: const Text('Get assistance with your complaint.'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat support will be added next.'),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Support'),
              subtitle: const Text('Connect with the civic help desk.'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support contact will be added next.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ACCOUNT
// ============================================================

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 55)),

          const SizedBox(height: 15),

          const Text(
            'NagrikWaatch User',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          const Text('Citizen Account'),

          const SizedBox(height: 30),

          AccountOption(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile page will be added next.'),
                ),
              );
            },
          ),

          AccountOption(
            icon: Icons.verified_user,
            title: 'Identity Verification',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('DigiLocker verification will be added next.'),
                ),
              );
            },
          ),

          AccountOption(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings page will be added next.'),
                ),
              );
            },
          ),

          AccountOption(
            icon: Icons.info_outline,
            title: 'About NagrikWaatch',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('About page will be added next.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ACCOUNT OPTION
// ============================================================

class AccountOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AccountOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
// ============================================================
// EXPLORE ISSUES PAGE
// ============================================================

class ExploreIssuesPage extends StatefulWidget {
  const ExploreIssuesPage({super.key});

  @override
  State<ExploreIssuesPage> createState() => _ExploreIssuesPageState();
}

class _ExploreIssuesPageState extends State<ExploreIssuesPage> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Roads',
    'Garbage',
    'Water',
    'Electricity',
    'Drainage',
  ];

  final List<Map<String, dynamic>> issues = [
    {
      'title': 'Broken Road',
      'category': 'Roads',
      'location': 'Kanpur',
      'status': 'Pending',
      'icon': Icons.construction,
    },
    {
      'title': 'Garbage Not Collected',
      'category': 'Garbage',
      'location': 'Civil Lines',
      'status': 'Under Review',
      'icon': Icons.delete_outline,
    },
    {
      'title': 'Water Leakage',
      'category': 'Water',
      'location': 'Swaroop Nagar',
      'status': 'Work in Progress',
      'icon': Icons.water_drop_outlined,
    },
    {
      'title': 'Damaged Electric Cable',
      'category': 'Electricity',
      'location': 'Kalyanpur',
      'status': 'Pending',
      'icon': Icons.electrical_services,
    },
  ];

  List<Map<String, dynamic>> get filteredIssues {
    if (selectedCategory == 'All') {
      return issues;
    }

    return issues
        .where((issue) => issue['category'] == selectedCategory)
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;

      case 'Under Review':
        return Colors.blue;

      case 'Work in Progress':
        return Colors.purple;

      case 'Resolved':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Issues')),

      body: Column(
        children: [
          // ==================================================
          // SEARCH
          // ==================================================

          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search civic issues...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // ==================================================
          // CATEGORY FILTER
          // ==================================================
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // ==================================================
          // ISSUE COUNT
          // ==================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${filteredIssues.length} Issues',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                const Icon(Icons.location_on_outlined, size: 18),

                const SizedBox(width: 5),

                const Text('Nearby'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ==================================================
          // ISSUES LIST
          // ==================================================
          Expanded(
            child: filteredIssues.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 15),
                        Text(
                          'No issues found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredIssues.length,
                    itemBuilder: (context, index) {
                      final issue = filteredIssues[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportDetailsPage(
                                  reportTitle: issue['title'],
                                  reportId: 'NW-000${index + 1}',
                                  category: issue['category'],
                                  status: issue['status'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // ICON
                                CircleAvatar(
                                  radius: 27,
                                  child: Icon(issue['icon']),
                                ),

                                const SizedBox(width: 15),

                                // DETAILS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        issue['title'],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(issue['location']),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusColor(issue['status'])
                                              .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          issue['status'],
                                          style: TextStyle(
                                            color: getStatusColor(
                                              issue['status'],
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
