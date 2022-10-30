import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;

  final VoidCallback onTap;

  final bool hasCircularBorder;

  const MainButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.hasCircularBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: hasCircularBorder
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    )
                  : null,
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: onTap,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white),
            )));
  }
}
