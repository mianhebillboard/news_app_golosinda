import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      refreshingText: '', 
      completeText: '', 
      failedText: '',
      idleText: '', 
      releaseText: '',
      height: 60.0, 
      completeDuration: const Duration(milliseconds: 800),
      refreshingIcon: const CupertinoActivityIndicator(),
      releaseIcon: const Icon(Icons.refresh, color: Colors.white)
    );
  }
}

// Reusable Pull-to-Refresh Widget
class PullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh; // Callback for refresh logic

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<PullToRefresh> createState() => PullToRefreshState();
}

class PullToRefreshState extends State<PullToRefresh> {
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    refreshController.dispose(); // Dispose the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: const BouncingScrollPhysics(),
      controller: refreshController,
      header: const CustomHeader(),
      onRefresh: () async {
        try {
          await widget.onRefresh(); // Call the provided refresh function
          refreshController.refreshCompleted();
        } catch (e) {
          refreshController.refreshFailed();
          debugPrint("Refresh error: $e");
        }
      },
      child: widget.child, // Display the passed child widget
    );
  }
}
