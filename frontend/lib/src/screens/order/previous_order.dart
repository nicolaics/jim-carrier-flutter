import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PreviousOrderScreen extends StatefulWidget {
  const PreviousOrderScreen({super.key});

  @override
  State<PreviousOrderScreen> createState() => _PreviousOrderScreenState();
}

class _PreviousOrderScreenState extends State<PreviousOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  // Dummy data for listing
  List<Map<String, dynamic>> listingData = [
    {
      "name": "Carrier 1",
      "destination": "Seoul",
      "price": "₩5000 per kg",
      "available_weight": "10 kg",
      "flight_date": "Nov 15, 2024",
      "profile_pic": null
    },
    {
      "name": "Carrier 2",
      "destination": "Busan",
      "price": "₩4000 per kg",
      "available_weight": "15 kg",
      "flight_date": "Nov 20, 2024",
      "profile_pic": null
    },
  ];

  // Dummy data for orders
  List<Map<String, dynamic>> orderData = [
    {
      "name": "Carrier 1",
      "destination": "Seoul",
      "price": "₩5000 per kg",
      "available_weight": "10 kg",
      "flight_date": "Nov 15, 2024",
      "order_weight": "5 kg",
    },
    {
      "name": "Carrier 2",
      "destination": "Busan",
      "price": "₩4000 per kg",
      "available_weight": "15 kg",
      "flight_date": "Nov 20, 2024",
      "order_weight": "7 kg",
    },
  ];

  bool isListingView = true; // Boolean to toggle between listing and order view
  int _selectedRating = 0; // For storing the selected star rating

  void _performSearch() {
    final query = _searchController.text;
    print("Searching for: $query");
  }

  void _showReviewModal(String carrierName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be resized with the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjust for keyboard
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 12),
                Text(
                  "Leave a Review for $carrierName",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("Rate out of 5",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                RatingBar.builder(
                  initialRating: _selectedRating.toDouble(), // Sets initial rating
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true, // Allow half-star ratings if desired
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _selectedRating = rating.toInt(); // Update selected rating
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Write your review",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    print("Review Submitted: ${_reviewController.text}, Rating: $_selectedRating");
                    _reviewController.clear();
                    setState(() {
                      _selectedRating = 0; // Reset rating after submission
                    });
                    Navigator.pop(context); // Close the modal
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab-like buttons
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("LISTING", 0),
                const SizedBox(width: 8),
                _buildTabButton("ORDER", 1),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display either Listing or Order data based on the button clicked
          Expanded(
            child: isListingView ? _buildListingView() : _buildOrderView(),
          ),
        ],
      ),
    );
  }

  // Helper method to build the Tab-like button
  Widget _buildTabButton(String label, int index) {
    bool isSelected = (index == 0 && isListingView) || (index == 1 && !isListingView);

    return GestureDetector(
      onTap: () {
        setState(() {
          isListingView = index == 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Method to build the Listing view
  Widget _buildListingView() {
    return ListView.builder(
      itemCount: listingData.length,
      itemBuilder: (context, index) {
        final item = listingData[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundImage: AssetImage(item["profile_pic"] ?? 'frontend/assets/images/welcomePage/welcome_screen.png'), // Placeholder image
              radius: 20,
            ),
            title: Text(
              item["name"] ?? "Name",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["destination"] ?? "Destination"),
                Text(item["price"] ?? "Price"),
                Text(item["available_weight"] ?? "Available Weight"),
                Text(item["flight_date"] ?? "Flight Date"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Handle edit action here
                    print("Edit item: ${item['name']}");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Handle delete action here
                    setState(() {
                      listingData.removeAt(index); // Remove the item from the list
                    });
                    print("Deleted item: ${item['name']}");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to build the Order view with the "Leave Review" button
  Widget _buildOrderView() {
    return ListView.builder(
      itemCount: orderData.length,
      itemBuilder: (context, index) {
        final item = orderData[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] ?? "Name",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(item["destination"] ?? "Destination"),
                Text(item["price"] ?? "Price"),
                Text(item["available_weight"] ?? "Available Weight"),
                Text(item["flight_date"] ?? "Flight Date"),
                Text("Order Weight: ${item["order_weight"]} kg"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("View Status pressed for ${item["name"]}");
                      },
                      child: const Text("View Status"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _showReviewModal(item["name"]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Text("Leave Review"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}