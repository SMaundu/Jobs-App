import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class CustomSaveButton extends StatefulWidget {
  const CustomSaveButton({
    Key? key,
    this.size = 24.0,
    this.isLiked = false,
    this.onTap,
    this.color = Colors.blue,
  }) : super(key: key);

  final double size;

  final Color color;

  final Future<bool?> Function(bool isLiked)? onTap;

  final bool isLiked;

  @override
  State<StatefulWidget> createState() => CustomSaveButtonState();
}

class CustomSaveButtonState extends State<CustomSaveButton>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  bool _isLiked = false;

  bool? get isLiked => _isLiked;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _isLiked = widget.isLiked;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void didUpdateWidget(CustomSaveButton oldWidget) {
    _isLiked = widget.isLiked;

    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: isLoading
          ? SizedBox(
              height: widget.size,
              width: widget.size,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: widget.color,
                ),
              ),
            )
          : HeroIcon(
              HeroIcons.bookmark,
              style: _isLiked ? HeroIconStyle.solid : null,
              size: widget.size,
              color: widget.color,
            ),
    );
  }

  void onTap() {
    setState(() {
      isLoading = true;
    });
    if (widget.onTap != null) {
      widget.onTap!(_isLiked).then((bool? isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!(_isLiked));
    }
  }

  void _handleIsLikeChanged(bool? isLiked) {
    if (isLiked != null && isLiked != _isLiked) {
      _isLiked = isLiked;
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        setState(() {
          if (_isLiked) {
            _controller!.reset();
            _controller!.forward();
          }
        });
      }
    }
  }
}
