import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SportsListScreen(),
    );
  }
}

class SportsListScreen extends StatefulWidget {
  @override
  _SportsListScreenState createState() => _SportsListScreenState();
}

class _SportsListScreenState extends State<SportsListScreen> {
  List<Map<String, dynamic>> sports = [
    {
      "title": "Cricket Bat",
      "subtitle": "Willow bat for powerful shots",
      "price": 1200,
      "image":
          "https://www.shutterstock.com/image-vector/illustration-cricket-bat-on-isolated-600nw-2452695663.jpg"
    },
    {
      "title": "Football",
      "subtitle": "Durable synthetic leather ball",
      "price": 800,
      "image":
          "https://media.istockphoto.com/id/610241662/photo/soccer-ball-isolated-on-the-white-background.jpg?s=612x612&w=0&k=20&c=f7EWJti8x_JFmDxA8CMJvi1ulMlPjTdDP69HBWy9Hb4="
    },
    {
      "title": "Badminton Racket",
      "subtitle": "Lightweight carbon frame",
      "price": 950,
      "image":
          "https://scssports.in/cdn/shop/files/41toB5Vev_L._SX679__1_535x.jpg?v=1719060731"
    },
    {
      "title": "Tennis Ball",
      "subtitle": "Pack of 3 high-bounce balls",
      "price": 300,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfu0FwQAqJSyRlQzjAo9P1ybN40dBcWgwDZw&s"
    },
    {
      "title": "Hockey Stick",
      "subtitle": "Wooden stick for beginners",
      "price": 1100,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWVnyxuTbsDrXBxvZomNl-3ucpcJK77rDqUg&s"
    },
    {
      "title": "Basketball",
      "subtitle": "Official size rubber ball",
      "price": 700,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmePY2S9UAsZAyEDVPBwVRHUAWeOcGlYyBP-gDYyGJx4zNV1tMUDYUNfjEpdR0kdZc7dc&usqp=CAU"
    },
  ];

  List<Map<String, dynamic>> cart = []; // 🛒 cart list

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item["title"]} added to cart"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sports Store"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Show cart in a new screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        itemCount: sports.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final item = sports[index];
          return ListTile(
            leading: Image.network(
              item["image"],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
            title: Text(
              item["title"],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item["subtitle"]),
            trailing: SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "₹${item["price"]}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(60, 28),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => addToCart(item),
                    child: Text("Buy", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  CartScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.blue,
      ),
      body: cart.isEmpty
          ? Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading: Image.network(
                    item["image"],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item["title"]),
                  subtitle: Text("₹${item["price"]}"),
                );
              },
            ),
    );
  }
}
