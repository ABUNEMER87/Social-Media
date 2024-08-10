import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_stack/image_stack.dart';

class FollowersCard extends StatefulWidget {
  const FollowersCard({super.key, required this.content, required this.count});
  final String content;
  final int count;

  @override
  State<FollowersCard> createState() => _FollowersCardState();
}

class _FollowersCardState extends State<FollowersCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Column(
        children: [
          ImageStack(
            imageSource: ImageSource.Asset,
            imageList: const [
              'assets/images/man.png',
              'assets/images/woman.png',
            ],
            totalCount: 0,
            imageRadius: 35,
            imageBorderWidth: 1,
            imageBorderColor: Colors.white,
          ),
          const Gap(10),
          Row(
            children: [
              Text('${widget.count}'),
              const Gap(5),
              Text(widget.content),
            ],
          )
        ],
      ),
    );
  }
}
