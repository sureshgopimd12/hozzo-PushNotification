import 'package:flutter/material.dart';
import 'package:hozzo/theme/app-theme.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onOptionTap;
  final EdgeInsetsGeometry padding;
  final String header;
  final bool showArrow;

  OptionTile({
    this.header,
    @required this.title,
    @required this.icon,
    @required this.onOptionTap,
    this.padding,
    this.showArrow = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            onTap: () => onOptionTap(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      header ?? ' ',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                Visibility(
                  visible: showArrow,
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0, right: 6.0, top: 10.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                title,
                style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            contentPadding: padding,
            leading: Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 7),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: new BorderRadius.all(
                    new Radius.circular(5.0),
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Divider(
            height: 0,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
