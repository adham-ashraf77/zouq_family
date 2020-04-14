import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return new SizedBox.fromSize(
      size: preferredSize,
      child: new LayoutBuilder(builder: (context, constraint) {
        final width = constraint.maxWidth * 8;
        return new ClipRect(
          child: new OverflowBox(
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            child: new SizedBox(
                width: width,
                height: width,
                child: new Padding(
                  padding: new EdgeInsets.only(
                      bottom: width / 2 - preferredSize.height / 2),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                  ),
                )),
          ),
        );
      }),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}
