import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyCart.dart';
import 'MyProfile.dart';
import 'NotificationsPage.dart';
import 'urunler.dart'; // Urun sınıfının bulunduğu dosya

class HomePage extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final bool isTurkish;

  const HomePage({Key? key, required this.username, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Urun> cartItems = []; // Sepete eklenen ürünlerin listesi

  @override
  void initState() {
    super.initState();
    // Kullanıcı sepetini yükle
    _loadCart();
  }

  // Kullanıcının sepetini yükleme işlevi
  void _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList(widget.username);
    if (cartJsonList != null) {
      setState(() {
        cartItems = cartJsonList.map((json) => Urun.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  // Kullanıcının sepetini kaydetme işlevi
  void _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJsonList = cartItems.map((urun) => jsonEncode(urun.toJson())).toList();
    await prefs.setStringList(widget.username, cartJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isTurkish! ? 'Tekrar Hoşgeldin!' : 'Welcome Back!',
              style: TextStyle(fontSize: 17,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              widget.username,
              style: TextStyle(fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black,),
            ),
          ],
        ),
      ),
      body: _widgetOptions(context).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addToCart(Urun urun) {
    setState(() {
      cartItems.add(urun); // Sepete ürün ekle
      _saveCart(); // Sepeti kaydet
    });
  }

  void _addToCart(BuildContext context, Urun urun) {
    final _HomePageState state = context.findAncestorStateOfType<_HomePageState>()!;
    state.addToCart(urun);
    setState(() {
      // İşlemleri buraya ekleyin
    });
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      ShopPage(
        username: widget.username,
        addToCart: (urun) {
          addToCart(urun); // addToCart çağrısı doğrudan bu sınıf içinde olduğundan, bu şekilde çağrabiliriz
        }, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,
      ),
      MyCartPage(cartItems: cartItems, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
      NotificationsPage(isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
      MyProfile(username: widget.username, isDarkMode: widget.isDarkMode, isTurkish: widget.isTurkish,),
    ];
  }
}

class ShopPage extends StatefulWidget {
  final String username;
  final Function(Urun) addToCart; // addToCart parametresi eklendi
  final bool isDarkMode;
  final bool isTurkish;

  ShopPage({required this.username, required this.addToCart, required this.isDarkMode, required this.isTurkish});
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late List<Urun> filteredUrunler = urunler; // filteredUrunler listesini burada tanımlayın
  TextEditingController _searchController = TextEditingController();
  late Map<int, bool> isAddedToCartMap = {}; // isAddedToCartMap haritasını burada tanımlayın

  // SharedPreferences nesnesi
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    // SharedPreferences örneğini yükleyin
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      // Kaydedilmiş sepet durumunu yükle
      _loadCartState();
    });
  }

  // Kaydedilmiş sepet durumunu yükleme işlevi
  void _loadCartState() {
    for (int i = 0; i < filteredUrunler.length; i++) {
      bool? added = _prefs.getBool('${widget.username}_cart_$i');
      if (added != null) {
        setState(() {
          isAddedToCartMap[i] = added;
        });
      } else {
        isAddedToCartMap[i] = false;
      }
    }
  }

  // Sepete eklenen ürünlerin durumunu SharedPreferences'e kaydetme işlevi
  void _saveCartState() {
    isAddedToCartMap.forEach((index, added) {
      _prefs.setBool('${widget.username}_cart_$index', added);
    });
  }

  void filterUrunler(String query) {
    List<Urun> searchResult = urunler
        .where((urun) => urun.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredUrunler = searchResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.isTurkish! ? 'Market Sayfası' : 'Shop Page',style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black,),),
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,

      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: filterUrunler,
              decoration: InputDecoration(
                hintText: widget.isTurkish! ? 'Arama Yapın...' : 'What are you looking for...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  //zzborderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredUrunler.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                filteredUrunler[index].imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredUrunler[index].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  filteredUrunler[index].price,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(isAddedToCartMap[index] ?? false ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                        onPressed: () {
                          setState(() {
                            isAddedToCartMap[index] = !(isAddedToCartMap[index] ?? false); // Durumu tersine çevir

                            if (isAddedToCartMap[index] ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${filteredUrunler[index].name} added to cart'),
                                ),
                              );
                              widget.addToCart(filteredUrunler[index]); // Sepete ürün ekle, bu satırı değiştirin
                            }
                          });
                        },
                      ),
                    ],
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