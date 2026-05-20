import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_header.dart';


class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  final Color primaryColor = const Color(0xFF387B40);
  final Color lightGreen = const Color(0xFF8CC18D);
  final user = FirebaseAuth.instance.currentUser;

  void _showAddressDialog({String? addressId, Map<String, dynamic>? currentData}) {
    final labelController = TextEditingController(text: currentData?['label'] ?? '');
    final detailsController = TextEditingController(text: currentData?['details'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          addressId == null ? 'Add Address' : 'Edit Address',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontFamily: 'Georgia'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: InputDecoration(
                labelText: 'Label (e.g. Home, Office)',
                labelStyle: TextStyle(color: lightGreen),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(
                labelText: 'Full Address',
                labelStyle: TextStyle(color: lightGreen),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (labelController.text.isEmpty || detailsController.text.isEmpty) return;

              final data = {
                'label': labelController.text,
                'details': detailsController.text,
                'timestamp': FieldValue.serverTimestamp(),
              };

              if (addressId == null) {
                await FirestoreService().addAddress(user!.uid, data);
              } else {
                await FirestoreService().updateAddress(user!.uid, addressId, data);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressDialog(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade400],
            stops: const [0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomHeader(title: 'Saved Addresses'),
              Expanded(
                child: user == null
                    ? const Center(child: Text('Please login to view addresses'))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirestoreService().getAddresses(user!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(color: primaryColor));
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_outlined, size: 80, color: lightGreen.withValues(alpha: 0.5)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No addresses saved',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Georgia',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final doc = snapshot.data!.docs[index];
                              final address = doc.data() as Map<String, dynamic>;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: lightGreen, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(20),
                                  leading: CircleAvatar(
                                    backgroundColor: lightGreen.withValues(alpha: 0.2),
                                    child: Icon(Icons.location_on, color: primaryColor),
                                  ),
                                  title: Text(
                                    address['label'] ?? 'Address',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      address['details'] ?? '',
                                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showAddressDialog(
                                          addressId: doc.id,
                                          currentData: address,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          await FirestoreService().deleteAddress(user!.uid, doc.id);
                                        },
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}
