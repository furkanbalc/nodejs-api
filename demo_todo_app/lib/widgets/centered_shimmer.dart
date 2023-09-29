import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CenteredShimmer extends StatelessWidget {
  const CenteredShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const Column(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text(
              'Downloading...',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
