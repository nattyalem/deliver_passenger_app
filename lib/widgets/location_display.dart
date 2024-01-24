import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/models/place_predictions.dart';

class LocationDisplay extends StatelessWidget {
  final PlacePredictions prediction;
  const LocationDisplay({Key? key, required this.prediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10.w),
            Icon(Icons.location_on, color: Colors.grey.shade400),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(prediction.mainText.toString(),
                      style: roboto50015,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(prediction.secondaryText.toString(),
                      style: roboto50012.copyWith(color: Colors.grey.shade400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        Divider(
            height: .5.h,
            indent: 40.w,
            endIndent: 40.w,
            color: Colors.grey.shade200)
      ],
    );
  }
}
