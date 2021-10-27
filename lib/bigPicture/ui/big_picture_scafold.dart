import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/bigPicture/state/big_picture_state_provider.dart';
import 'package:turing_deal/bigPicture/ui/big_picture_resume_list.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';

/// This class makes sure there are data to show in the reume list
/// and takes care of the floating action button animation
class BigPictureScafold extends StatefulWidget {
  const BigPictureScafold({Key? key}) : super(key: key);

  @override
  _BigPictureScafoldState createState() => _BigPictureScafoldState();
}

class _BigPictureScafoldState extends State<BigPictureScafold>
    with SingleTickerProviderStateMixin {
  static const int minTickerForShowCompatData = 10;

  bool _showFloatingButton = true;

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  )..forward();

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BigPictureStateProvider bigPictureState =
    Provider.of<BigPictureStateProvider>(context, listen: false);

    // Return the big picture screen
    Map<StockTicker, BuyAndHoldStrategyResult> data = bigPictureState.getBigPictureData();

    if(data.length == 0){
      return Text('No strategies');
    }else{
      // Hide compact data if there are not enough data
      if(data.length < minTickerForShowCompatData){
        _controller.reverse();
        _showFloatingButton = false;
      }
      return NotificationListener<UserScrollNotification>(
        onNotification: (scroll) {
          if (scroll.direction == ScrollDirection.reverse && _showFloatingButton) {
            _controller.reverse();
            _showFloatingButton = false;
          } else if (scroll.direction == ScrollDirection.forward &&
              !_showFloatingButton) {
            if(data.length >= minTickerForShowCompatData) {
              _controller.forward();
              _showFloatingButton = true;
            }
          }
          return true;
        },
        child: Scaffold(
          body: BigPictureResumeList(data),
          floatingActionButton: ScaleTransition(
            scale: _animation,
            child: FloatingActionButton(
                onPressed: () => bigPictureState.toogleCompactView(),
                child: Icon(
                    bigPictureState.isCompactView() ? Icons.view_agenda_rounded : Icons.view_comfortable_sharp
                )
            ),
          ),
        ),
      );
    }
  }
}
