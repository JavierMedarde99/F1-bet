
import 'package:flutter/material.dart';
class Cardpage extends StatelessWidget {

final Image image;
final String text;
final Container container;

Cardpage({required this.image, required this.text, required this.container});


  @override
  Widget build(BuildContext context) {
    return Padding(
                  
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          /// 📷 MITAD IZQUIERDA - IMAGEN
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              child: image,
                            ),
                          ),

                          /// 🏁 MITAD DERECHA - INFO
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Nombre circuito
                                  Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  /// Botón dinámico
                                  container,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
  }
}