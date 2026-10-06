import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> cart = [];

  String searchText = '';
  String selectedCategory = 'Tümü';

  final FocusNode searchFocusNode = FocusNode();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/products.json');

      final List<dynamic> jsonData = jsonDecode(jsonString);

      setState(() {
        products = jsonData
            .map((json) => Product.fromJson(json))
            .toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(
        'Ürünler yüklenirken hata oluştu: $e',
      );
    }
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Tümü',
      ...products
          .map((product) => product.category)
          .toSet(),
    ];

    final List<Product> filteredProducts =
        products.where((product) {
      final String search =
          searchText.toLowerCase();

      final bool matchesSearch =
          product.name
                  .toLowerCase()
                  .contains(search) ||
              product.description
                  .toLowerCase()
                  .contains(search);

      final bool matchesCategory =
          selectedCategory == 'Tümü' ||
              product.category ==
                  selectedCategory;

      return matchesSearch &&
          matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mini Katalog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CartScreen(
                        cart: cart,
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.all(4),
                    decoration:
                        const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              20,
              16,
              10,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ürünler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          // Arama
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: TextField(
              focusNode: searchFocusNode,
              autofocus: false,
              keyboardType:
                  TextInputType.text,
              textInputAction:
                  TextInputAction.search,
              onTap: () {
                searchFocusNode
                    .requestFocus();
              },
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration:
                  InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon:
                    const Icon(
                  Icons.search,
                ),
                suffixIcon:
                    searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                searchText =
                                    '';
                              });
                            },
                            icon:
                                const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Kategoriler
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection:
                  Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount:
                  categories.length,
              itemBuilder:
                  (context, index) {
                final String category =
                    categories[index];

                final bool isSelected =
                    category ==
                        selectedCategory;

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 8,
                  ),
                  child: ChoiceChip(
                    label:
                        Text(category),
                    selected:
                        isSelected,
                    onSelected:
                        (selected) {
                      setState(() {
                        selectedCategory =
                            category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Ürünler
          Expanded(
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'Ürün bulunamadı.',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets
                                .all(16),
                        itemCount:
                            filteredProducts
                                .length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio:
                              0.60,
                        ),
                        itemBuilder:
                            (context, index) {
                          final Product
                              product =
                              filteredProducts[
                                  index];

                          return ProductCard(
                            product: product,
                            onAddToCart:
                                () {
                              setState(() {
                                cart.add(
                                    product);
                              });

                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(
                                    '${product.name} sepete eklendi',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}