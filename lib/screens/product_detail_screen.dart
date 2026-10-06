import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen
    extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Ürün Detayı'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
                errorBuilder:
                    (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.image_outlined,
                    size: 100,
                  );
                },
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    product.name,
                    style:
                        const TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    '${product.price.toStringAsFixed(2)} TL',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.blue.shade700,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  const Text(
                    'Ürün Açıklaması',
                    style:
                        TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    product.description,
                    style:
                        const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        ElevatedButton
                            .icon(
                      onPressed: () {
                        onAddToCart();

                        ScaffoldMessenger
                            .of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ürün sepete eklendi',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons
                            .shopping_cart_outlined,
                      ),
                      label:
                          const Text(
                        'Sepete Ekle',
                        style:
                            TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}