import 'dart:async';

import 'package:assignment/models/user_model.dart';
import 'package:assignment/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/user_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserController _userController = UserController();
  final StreamController<List<User>> _streamController =
  StreamController<List<User>>.broadcast();
  final ScrollController _scrollController = ScrollController();
  List<User> items = [];
  bool isLoading = false;
  String searchQuery = '';

  String formatPhoneNumber(String phoneNumber, String countryCode) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (!phoneNumber.startsWith('+')) {
      return '$countryCode$phoneNumber';
    }
    return phoneNumber;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<User> fetchedUsers = await _userController.fetchUsers();
      setState(() {
        items.addAll(fetchedUsers);
        _streamController.sink.add(items);
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  void _filterUsers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _streamController.sink.add(
        items.where((user) =>
        user.name?.first?.toLowerCase().contains(searchQuery) ?? false)
            .toList(),
      );
    });
  }

  Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $phoneNumber. Please try again.'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  Future<void> sendSMS(
      BuildContext context, String phoneNumber, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not send SMS to $phoneNumber. Please try again.'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Dating List",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: _filterUsers,
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<User>>(
                        stream: _streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text("No data available"));
                          }

                          var data = snapshot.data!;

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: data.length + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == data.length) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              var user = data[index];
                              var location =
                                  '${user.location?.city}, ${user.location?.state}';
                              var imageUrl = user.picture?.thumbnail ?? '';

                              return Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.calendar_month),
                                      title: const Text("Dinner"),
                                      trailing: const Icon(Icons.more_vert),
                                    ),
                                    const Divider(height: 10, color: Colors.grey),
                                    ListTile(
                                      leading: Container(

                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(imageUrl),
                                        ),
                                      ),
                                      title: Text(user.name?.first ?? "Unknown"),
                                      subtitle: Text("3 km from you"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.message,color: Colors.blueAccent,),
                                            onPressed: () {
                                              final phoneNumber = user.phone ?? "";
                                              sendSMS(context, phoneNumber, "Hi! How are you?");
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            icon: const Icon(Icons.phone,color: Colors.blueAccent,),
                                            onPressed: () {
                                              final phoneNumber = user.phone ?? "";
                                              final formattedNumber =
                                              formatPhoneNumber(phoneNumber, '+1');
                                              makePhoneCall(context, formattedNumber);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: const [
                                                    Icon(Icons.calendar_month),
                                                    SizedBox(width: 5),
                                                    Text("Date "),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(user.gender ?? "N/A"),
                                                SizedBox(height: 5),
                                                Text(user.cell.toString() ?? ""),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1.9,
                                            color: Colors.grey,
                                            height: 80,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.location_on_outlined),
                                                      SizedBox(width: 5),
                                                      Text("Location"),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 28.0),
                                                  child: Text(location,overflow: TextOverflow.ellipsis,),
                                                )
                                                
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
