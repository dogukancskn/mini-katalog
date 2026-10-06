import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(
                product: product,
                onAddToCart:
                    onAddToCart,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(12),
                color:
                    Colors.grey.shade100,
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
                      Icons
                          .image_outlined,
                      size: 60,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  10,
                  8,
                  10,
                  8,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      product.description,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors
                            .grey.shade600,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '${product.price.toStringAsFixed(2)} TL',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .primary,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      height: 34,
                      child:
                          ElevatedButton(
                        onPressed:
                            onAddToCart,
                        style: ElevatedButton
                            .styleFrom(
                          padding:
                              EdgeInsets.zero,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                        child:
                            const Text(
                          'Sepete Ekle',
                          style:
                              TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}