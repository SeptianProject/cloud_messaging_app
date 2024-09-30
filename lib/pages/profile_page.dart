import 'package:fcm_app/main.dart';
import 'package:fcm_app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _future = supabase.from('profiles').select();
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
// final _avatarController = TextEditingController();
  final websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getInitProfile();
  }

  @override
  void dispose() {
    usernameController.dispose();
    fullnameController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  Future<void> _getInitProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      usernameController.text = data['username'];
      fullnameController.text = data['full_name'];
      websiteController.text = data['website'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final users = snapshot.data!;
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: users.length,
                          itemBuilder: ((context, index) {
                            final user = users[index];
                            return ListTile(
                              title: Text(user['username']),
                              subtitle: Text(user['full_name']),
                              trailing: Text(user['website']),
                            );
                          })),
                    ),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: fullnameController,
                      decoration: const InputDecoration(labelText: 'Fullname'),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: websiteController,
                      decoration: const InputDecoration(labelText: 'Website'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        final username = usernameController.text.trim();
                        final fullname = fullnameController.text.trim();
                        final website = websiteController.text.trim();
                        final userId = supabase.auth.currentUser!.id;

                        await supabase.from('profiles').update({
                          'username': username,
                          'full_name': fullname,
                          'website': website,
                        }).eq('id', userId);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.indigoAccent),
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const Spacer()
                  ],
                ));
          }),
      bottomNavigationBar: BottomNavbar(
        index: 1,
        onFirst: () {
          Navigator.pushNamed(context, '/home');
        },
        onSecond: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
