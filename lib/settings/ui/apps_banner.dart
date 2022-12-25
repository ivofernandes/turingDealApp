import 'package:flutter/material.dart';
import 'package:turing_deal/shared/environment.dart';
import 'package:turing_deal/shared/ui/Web.dart';

class AppsBanner extends StatelessWidget {
  const AppsBanner({super.key});

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
                  onTap: () =>
                      Web.launchLink(context, Environment.PLAY_STORE_URL),
                  child: Image.asset(
                    'assets/images/stores/play_store.png',
                    height: 75,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () =>
                      Web.launchLink(context, Environment.APP_STORE_URL),
                  child: Image.asset('assets/images/stores/app_store.png',
                      width: (width - 40) / 2, height: 50),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
