import 'package:flutter/material.dart';

class MockedDataDisclaimer extends StatelessWidget {
  const MockedDataDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
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
    );
  }
}
