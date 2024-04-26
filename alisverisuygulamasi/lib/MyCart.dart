import 'dart:convert';

import 'package:alisverisuygulamasi/Odeme.dart';
import 'package:alisverisuygulamasi/urunler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartPage extends StatefulWidget {
  final List<Urun> cartItems; // Sepete eklenen ürünlerin listesi
  final bool isDarkMode;
  final bool isTurkish;

  const MyCartPage({Key? key, required this.cartItems, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  @override
  Widget build(BuildContext context) {
    double total = 0; // Toplam fiyatı hesaplamak için değişken
    for (var item in widget.cartItems) {
      total += double.parse(item.price.split(' ')[0]); // Ürün fiyatlarını topla
    }

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text(widget.isTurkish! ? 'Sepetim' : 'My Cart',style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black,),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    widget.cartItems[index].imageUrl,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(widget.cartItems[index].name,style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black),),
                  subtitle: Text(widget.cartItems[index].price,style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart,
                    color: widget.isDarkMode ? Colors.white : Colors.black,),
                    onPressed: () {
                      _removeFromCart(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}', // Toplam fiyatı görüntüle
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFA0B0B),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Odeme(Fiyat: total.toStringAsFixed(2), isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,)),
                    );                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      widget.isTurkish! ? 'Ödeme Yapın' : 'Buy',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.cartItems[index].name} removed from cart'),
        ),
      );
      // Sepetten ürünü kaldır
      widget.cartItems.removeAt(index);
      // Güncellenmiş sepet durumunu kaydet
      _saveCart();
    });
  }

  void _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJsonList = widget.cartItems.map((urun) => jsonEncode(urun.toJson())).toList();
    // Sepet durumunu SharedPreferences'e kaydet
    await prefs.setStringList('cart', cartJsonList);
  }
}
