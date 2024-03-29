import 'package:flutter/material.dart';

class Productcard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String offerTag;
  final Function onTap;
  const Productcard({super.key, required this.name, required this.imageUrl, required this.price, required this.offerTag, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.maxFinite,
                height: 160,
              ),
              SizedBox(height: 10),
              Text(name,
              style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text('Rs: $price',
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(offerTag,
                  style: const TextStyle(color: Colors.white,fontSize: 12),
                    overflow: TextOverflow.ellipsis,
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
