import 'package:flutter/material.dart';
import 'package:turing_deal/shared/environment.dart';
import 'package:turing_deal/shared/ui/Web.dart';

class MockedDataDisclaimer extends StatelessWidget {
  const MockedDataDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.amber
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Text(
                  'The data you are seeing is a small sample, to check the complete data please download the mobile app',
                  style: TextStyle(
                    color: Colors.amber,
                    overflow: TextOverflow.visible
                  ),
                ),
              )
            ],
          ),
          SizedBox(
              height: 10
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Web.launchLink(context, Environment.PLAY_STORE_URL),
                  child: Image.asset('assets/images/stores/play_store.png'),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Web.launchLink(context, Environment.APP_STORE_URL),
                  child: Image.asset(
                    'assets/images/stores/app_store.png',
                      width: (width-40)/2,
                      height: 50
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
