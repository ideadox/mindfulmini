import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ActivityHomeCard extends StatelessWidget {
  final String image;
  final bool isNetwrok;
  final VoidCallback? onTap;
  const ActivityHomeCard({
    super.key,
    required this.image,
    this.onTap,
    this.isNetwrok = false,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: isNetwrok? 
            
            CachedNetworkImageProvider(image) : 
            AssetImage(image)
             
             ,
          ),
        ),
      ),
    );
  }
}
