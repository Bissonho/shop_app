import 'package:flutter/material.dart';
import 'package:shop_app/pages/store_page.dart';
import 'cart_page.dart';

enum FilterOptions { Favorite, All }

enum TabItem { red, green, blue }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setCurrentPage,
        children: const <Widget>[
          StorePage(onlyFavorite: false),
          StorePage(onlyFavorite: true),
          CartPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 13,
          onTap: (index) {
            pc.animateToPage(index,
                duration: const Duration(microseconds: 400),
                curve: Curves.ease);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(
                  Icons.home,
                )),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
          ]),
    );
  }

  setCurrentPage(pagina) {
    setState(() {
      _selectedIndex = pagina;
    });
  }
}
