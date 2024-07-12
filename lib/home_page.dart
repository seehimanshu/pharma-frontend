import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pharmacy>> _pharmacies;

  @override
  void initState() {
    super.initState();
    _pharmacies = fetchPharmacies();
  }

  Future<List<Pharmacy>> fetchPharmacies() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/pharma/list'));

    if (response.statusCode == 200) {
      // Assuming the response body is a JSON object with a "pharma" key
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> pharmaciesJson = data['pharma'];
      return pharmaciesJson.map((pharma) => Pharmacy.fromJson(pharma)).toList();
    } else {
      throw Exception('Failed to load pharmacies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacies'),
      ),
      body: FutureBuilder<List<Pharmacy>>(
        future: _pharmacies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pharmacies found'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.map((pharmacy) => PharmacyCard(pharmacy: pharmacy)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class Pharmacy {
  final String id;
  final String name;
  final Address address;
  final Contact contact;
  final List<Medicine> medicines;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.medicines,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    var medicineList = json['medicines'] as List;
    List<Medicine> medicines = medicineList.map((i) => Medicine.fromJson(i)).toList();

    return Pharmacy(
      id: json['_id'],
      name: json['name'],
      address: Address.fromJson(json['address']),
      contact: Contact.fromJson(json['contact']),
      medicines: medicines,
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zip;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }
}

class Contact {
  final String phone;
  final String email;

  Contact({
    required this.phone,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
    );
  }
}

class Medicine {
  final String id;
  final String name;
  final String manufacturer;
  final double price;
  final int quantity;
  final DateTime expiryDate;

  Medicine({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.price,
    required this.quantity,
    required this.expiryDate,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      expiryDate: DateTime.parse(json['expiryDate']),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;

  PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pharmacy.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text('${pharmacy.address.street}, ${pharmacy.address.city}, ${pharmacy.address.state}, ${pharmacy.address.zip}'),
            SizedBox(height: 5),
            Text('Phone: ${pharmacy.contact.phone}'),
            SizedBox(height: 10),
            Text(
              'Medicines:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...pharmacy.medicines.map((medicine) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(medicine.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Manufacturer: ${medicine.manufacturer}'),
                    Text('Price: \$${medicine.price}'),
                    Text('Quantity: ${medicine.quantity}'),
                    Text('Expiry Date: ${medicine.expiryDate.toLocal().toShortDateString()}'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '${this.year}-${this.month}-${this.day}';
  }
}
