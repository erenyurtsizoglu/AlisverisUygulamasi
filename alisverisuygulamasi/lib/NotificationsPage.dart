import 'dart:math';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final bool isDarkMode;
  final bool isTurkish;
  const NotificationsPage({Key? key, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final List<Map<String, String>> notifications;

  @override
  void initState() {
    super.initState();
    // Bildirimler listesini oluştur
    notifications = [
      {
        'title': widget.isTurkish ? "Deri Ceket ürünü tükenmek üzere!" : "Leather Jacket product is about to run out!",
        'image': 'images/urun1.png',
      },
      {
        'title': widget.isTurkish ? "Kot Ceket ürününde %20 indirim!" : "20% discount on Denim Jacket product!",
        'image': 'images/urun2.png',
      },
      {
        'title': widget.isTurkish ? "Mont ürünü yeniden stoklarda!" : "Coat product back in stock!",
        'image': 'images/urun3.png',
      },
      {
        'title': widget.isTurkish ? "Blazer ürünü için son günler!" : "Last days for Blazer product!",
        'image': 'images/urun4.png',
      },
      {
        'title': widget.isTurkish ? "Pantolon ürünü satış rekoru kırdı!" : "Pants product broke sales record!",
        'image': 'images/urun5.png',
      },
      {
        'title': widget.isTurkish ? "Tişört ürününe yeni renk seçenekleri eklendi!" : "New color options added to T-shirt product!",
        'image': 'images/urun6.png',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        title: Text(widget.isTurkish ? 'Bildirimler' : 'Notifications',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(notifications[index]['image']!),
              ),
              title: Text(
                notifications[index]['title']!,
                style: TextStyle(fontSize: 16,
                  color: widget.isDarkMode ? Colors.black : Colors.black,
                ),
              ),
              onTap: () {
                // Bildirim tıklandığında yapılacak işlemler
              },
            ),
          );
        },
      ),
    );
  }
}
