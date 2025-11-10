import 'package:flutter/material.dart';

void main() {
  runApp(const FoodMenuApp());
}

class FoodMenuApp extends StatelessWidget {
  const FoodMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetable Menu',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Vegetables Menu",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: const FoodListView(),
      ),
    );
  }
}

class FoodListView extends StatelessWidget {
  const FoodListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> foods = [
      {
        "name": "Carrot",
        "price": "₹60/kg",
        "desc": "Rich in Vitamin A and good for eyesight.",
        "image":
            "https://5.imimg.com/data5/SELLER/Default/2025/3/495998096/NY/DK/VW/66789684/fresh-red-carrot.jpg"
      },
      {
        "name": "Tomato",
        "price": "₹40/kg",
        "desc": "Juicy and tangy, used in curries and salads.",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg"
      },
      {
        "name": "Potato",
        "price": "₹35/kg",
        "desc": "A staple vegetable, used in many dishes.",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/4/47/Russet_potato_cultivar_with_sprouts.jpg"
      },
      {
        "name": "Broccoli",
        "price": "₹120/kg",
        "desc": "A green vegetable rich in nutrients.",
        "image":
            "https://www.chicagosfoodbank.org/wp-content/uploads/2022/03/Broccoli-1-1.jpg"
      },
      {
        "name": "Cauliflower",
        "price": "₹90/kg",
        "desc": "Versatile vegetable used in curries and fries.",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfE9Co-fyaLr9OTvmJR8Nr3HHw6Nmil5NJew&s"
      },
    ];

    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  foods[index]["image"]!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foods[index]["name"]!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Price: ${foods[index]["price"]!}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        foods[index]["desc"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
