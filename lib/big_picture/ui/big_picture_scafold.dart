import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/big_picture_resume_list.dart';

/// This class makes sure there are data to show in the reume list
/// and takes care of the floating action button animation
class BigPictureScaffold extends StatefulWidget {
  const BigPictureScaffold({super.key});

  @override
  _BigPictureScaffoldState createState() => _BigPictureScaffoldState();
}

class _BigPictureScaffoldState extends State<BigPictureScaffold>
    with SingleTickerProviderStateMixin {
  static const int minTickerForShowCompatData = 10;

  bool _showFloatingButton = true;

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);

    // Return the big picture screen
    final Map<StockTicker, BuyAndHoldStrategyResult> data =
        bigPictureState.getBigPictureData();

    if (data.isEmpty) {
      return const Text('No strategies');
    } else {
      // Hide compact data if there are not enough data
      if (data.length < minTickerForShowCompatData) {
        _controller.reverse();
        _showFloatingButton = false;
      }
      return NotificationListener<UserScrollNotification>(
        onNotification: (scroll) {
          if (scroll.direction == ScrollDirection.reverse &&
              _showFloatingButton) {
            _controller.reverse();
            _showFloatingButton = false;
          } else if (scroll.direction == ScrollDirection.forward &&
              !_showFloatingButton) {
            if (data.length >= minTickerForShowCompatData) {
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
              onPressed: bigPictureState.toogleCompactView,
              child: Icon(bigPictureState.isCompactView()
                  ? Icons.view_agenda_rounded
                  : Icons.view_comfortable_sharp),
            ),
          ),
        ),
      );
    }
  }
}
