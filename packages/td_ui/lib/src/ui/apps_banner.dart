import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';

class AppsBanner extends StatelessWidget {
  final String playStoreUrl;
  final String appStoreUrl;

  const AppsBanner({
    required this.playStoreUrl,
    required this.appStoreUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            'You can also enjoy better performance in our mobile apps',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Web.launchLink(context, playStoreUrl),
                  child: Image.asset(
                    'assets/images/stores/play_store.png',
                    height: 75,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Web.launchLink(context, appStoreUrl),
                  child: Image.asset('assets/images/stores/app_store.png', width: (width - 40) / 2, height: 50),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
