import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Count App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Count Example'),
        ),
        body: ListWidget(),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  const ListWidget({Key? key}) : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  // Initialize a list of counts for 100 items, all set to 0 initially.
  final List<int> _counts = List<int>.generate(100, (index) => 0);
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;

  @override
  void initState() {
    super.initState();

    // Add listener to the scroll controller.
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Check if the scroll position is at the bottom
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels != 0;

      if (isBottom) {
        // User has scrolled to the bottom
        _isScrolledToBottom = true;
      } else if (_isScrolledToBottom) {
        // User has scrolled back to the top after reaching the bottom
        setState(() {
          // Reset all counts
          for (int i = 0; i < _counts.length; i++) {
            _counts[i] = 0;
          }
        });
        _isScrolledToBottom = false; // Reset the bottom flag
      }
    }
  }

  @override
  void dispose() {
    // Dispose the scroll controller to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _counts.length,
      itemBuilder: (context, index) {
        return ListItemWidget(
          serialNumber: index + 1, // Adding 1 to start serial numbers from 1 instead of 0
          count: _counts[index],
          onIncrement: () {
            setState(() {
              _counts[index]++;
            });
          },
        );
      },
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final int serialNumber;
  final int count;
  final VoidCallback onIncrement;

  const ListItemWidget({
    Key? key,
    required this.serialNumber,
    required this.count,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(backgroundColor: Colors.blue,radius: 20,child: Text('$serialNumber',style: TextStyle(fontSize: 18),),),

          Text(
            '$count', // Display serial number and count
            style: const TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: onIncrement,
            child: const Text("+"),
          ),
        ],
      ),
    );
  }
}
