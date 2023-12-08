import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;
  final Widget nav;
  final bool disableFocus;

  final double height;
  final EdgeInsetsGeometry padding;

  const MyScaffold({
    this.body = const SizedBox(),
    this.nav = const SizedBox(),
    this.disableFocus = true,
    this.height = 60,
    this.padding = const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              if (disableFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: body,
                ),
                Container(
                  padding: padding,
                  width: double.infinity,
                  height: height,
                  child: nav,
                )
              ],
            ),
          ),
        ),
      );
}
