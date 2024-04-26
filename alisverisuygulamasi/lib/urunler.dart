class Urun {
  final String imageUrl;
  final String name;
  final String price;

  Urun({required this.imageUrl, required this.name, required this.price});

  // JSON'dan Urun nesnesi oluşturan factory metodu
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
    );
  }

  // Urun nesnesini JSON'a dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
    };
  }
}

final List<Urun> urunler = [
  Urun(imageUrl: 'images/urun1.png', name: 'Deri Ceket', price: '10 dolar'),
  Urun(imageUrl: 'images/urun2.png', name: 'Kot Ceket', price: '20 dolar'),
  Urun(imageUrl: 'images/urun3.png', name: 'Mont', price: '30 dolar'),
  Urun(imageUrl: 'images/urun4.png', name: 'Blazer', price: '40 dolar'),
  Urun(imageUrl: 'images/urun5.png', name: 'Pantolon', price: '30 dolar'),
  Urun(imageUrl: 'images/urun6.png', name: 'Tişört', price: '25 dolar'),

];
