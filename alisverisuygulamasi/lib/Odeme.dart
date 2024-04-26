import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Odeme extends StatefulWidget {
  final String Fiyat;
  final bool isDarkMode;
  final bool isTurkish;

  const Odeme({Key? key, required this.Fiyat, required this.isDarkMode, required this.isTurkish}) : super(key: key);

  @override
  State<Odeme> createState() => _OdemeState();
}

class _OdemeState extends State<Odeme> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  bool _isValid = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[500] : Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.grey[800] : Theme.of(context).colorScheme.background,
        title: Text('Ödeme',
            style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 230,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isTurkish! ? 'Kredi Kartı' : 'Credit Card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCardNumberDigit(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardInfo('MM/YY', _expiryDateController),
                        _buildCardInfo('CVV', _cvvController),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: widget.isTurkish! ? 'Kart Numarası' : 'Card Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
                onChanged: (value) {
                  setState(() {
                    _isValid = value.length == 16;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(
                        labelText: widget.isTurkish! ? 'Son Kullanma Tarihi (AA/YY)' : 'expiration date (MM/YY)',
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFA0B0B),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: _makePayment,
                  child: Text(widget.isTurkish! ? 'Ödeme Yap' : 'Buy',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardNumberDigit() {
    return Container(
      width: 240, // Kare genişliği
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _cardNumberController.text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardInfo(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: TextInputType.number,
        maxLength: label == 'MM/YY' ? 5 : 3,
        onEditingComplete: () {
          setState(() {
            _isValid = _cardNumberController.text.length == 16 &&
                _expiryDateController.text.length == 5 &&
                _cvvController.text.length == 3;
          });
        },
      ),
    );
  }

  void _makePayment() async {
    if (_cardNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm boşlukları doldurun!'),
        ),
      );
    } else if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Geçersiz bilgiler! Lütfen kontrol edin.'),
        ),
      );
    } else {
      // Ödeme yapma işlemi
      // Burada ödeme işlemlerini gerçekleştirebilirsiniz

      // Ödeme başarılı olduğunda bildirim göster
      await showNotification();
    }
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Ödemeniz Başarılı!',
      'Ürün kargoya verildi.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
