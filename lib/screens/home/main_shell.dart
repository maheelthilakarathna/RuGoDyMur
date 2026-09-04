import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/nav_index_provider.dart';
import '../../widgets/offline_banner.dart';
import 'cart_screen.dart';
import 'catalogue_screen.dart';
import 'categories_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _screens = [
    CatalogueScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navIndex = context.watch<NavIndexProvider>().index;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OfflineBanner(),
            Expanded(child: IndexedStack(index: navIndex, children: _screens)),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) => BottomNavigationBar(
          currentIndex: navIndex,
          onTap: (i) => context.read<NavIndexProvider>().setIndex(i),
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('${cart.itemCount}'),
                isLabelVisible: cart.itemCount > 0,
                child: const Icon(Icons.shopping_cart_rounded),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
