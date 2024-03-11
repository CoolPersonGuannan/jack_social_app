import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';

class GPTSummaryScreen extends StatefulWidget {
  const GPTSummaryScreen({
    super.key,
  });

  @override
  State<GPTSummaryScreen> createState() => _GPTSummaryScreenState();
}

class _GPTSummaryScreenState extends State<GPTSummaryScreen> {
  late final OpenAI _openAI;
  List<String> list = [];

  // @override
  // void initState(){
  //   super.initState();
  //   _handleSubmit();
  // }

  Future _handleSubmit() async {
    _openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    // Handle ChatGPT request and response
    final request = ChatCompleteText(
      messages: [
        Messages(
          role: Role.system,
          content: "You are a friend of the user. Give positive advices like from a real friend in 100 words. Make sure to be creative in ways to give out advices and don't start with Hey there! ",
        ),
      ],
      maxToken: 200,
      model: GptTurbo0631Model(),
    );
    for (var i = 0; i < 2; i++) {
      String response = "";
      var response1 = await _openAI.onChatCompletion(request: request);
      response = response1!.choices.first.message!.content.trim().replaceAll('"', '');
      list.add(response);
    }
    return list;
  }

  // final list = [
  //   "Let yourself acknowledge your low mood. Bottling it up won't help. Instead, see it as a wave passing through, like a storm rolling in at sea. It might feel powerful, but it will eventually move on. Take comfort in knowing this is temporary, and allow yourself to feel fully without judgment.",
  //   "Big goals might seem daunting, so focus on tiny sparks of joy instead. Maybe it's brewing a warm cup of your favorite tea, listening to a silly song, or watching a calming nature documentary. Find simple activities that bring you a flicker of pleasure, one step at a time.",
  //   "Feeling alone can be amplified by disconnection. Step outside yourself and connect with something external. Read a touching poem, listen to uplifting music, spend time in nature, or watch a movie that touches your soul. Reminding yourself of the vastness of the world and the beauty it holds can offer perspective and comfort.",
  //   "When words fail, express yourself through other means. Draw, paint, write, dance, sing – whatever allows your emotions to flow freely. Don't worry about perfection, just let your inner world spill onto the canvas or into the melody. Creativity can be a powerful tool for processing and releasing difficult emotions.",
  //   "Even if you feel like no one understands, millions face similar struggles. Reach out to a trusted friend, a helpline, or online communities. Sharing your burdens can lighten the load, and connecting with others who \"get it\" can be incredibly validating. You might be surprised by the support that awaits you."
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Some thoughts From your Friend"),
      ),
      body: FutureBuilder(
        future: _handleSubmit(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              child: GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: CustomGridDelegate(dimension: 240.0),
                // Try uncommenting some of these properties to see the effect on the grid:
                itemCount: 2, // The default is that the number of grid tiles is infinite.
                //scrollDirection: Axis.horizontal, // The default is vertical.
                //reverse: true, // The default is false, going down (or left to right).
                itemBuilder: (BuildContext context, int index) {
                  final math.Random random = math.Random(index);
                  return GridTile(
                    // header: GridTileBar(
                    //   title: Text('$index',
                    //       style: const TextStyle(color: Colors.black)),
                    // ),
                    child: Container(
                      margin: const EdgeInsets.all(12.0),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        gradient: const RadialGradient(
                          colors: <Color>[Color(0x0F88EEFF), Color(0x2F0099BB)],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(list[random.nextInt(list.length)])
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }
}

class CustomGridDelegate extends SliverGridDelegate {
  CustomGridDelegate({required this.dimension});

  // This is the desired height of each row (and width of each square).
  // When there is not enough room, we shrink this to the width of the scroll view.
  final double dimension;

  // The layout is two rows of squares, then one very wide cell, repeat.

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // Determine how many squares we can fit per row.
    int count = constraints.crossAxisExtent ~/ dimension;
    if (count < 1) {
      count = 1; // Always fit at least one regardless.
    }
    final double squareDimension = constraints.crossAxisExtent / count;
    return CustomGridLayout(
      crossAxisCount: count,
      fullRowPeriod:
      3, // Number of rows per block (one of which is the full row).
      dimension: squareDimension,
    );
  }

  @override
  bool shouldRelayout(CustomGridDelegate oldDelegate) {
    return dimension != oldDelegate.dimension;
  }
}

class CustomGridLayout extends SliverGridLayout {
  const CustomGridLayout({
    required this.crossAxisCount,
    required this.dimension,
    required this.fullRowPeriod,
  })  : assert(crossAxisCount > 0),
        assert(fullRowPeriod > 1),
        loopLength = crossAxisCount * (fullRowPeriod - 1) + 1,
        loopHeight = fullRowPeriod * dimension;

  final int crossAxisCount;
  final double dimension;
  final int fullRowPeriod;

  // Computed values.
  final int loopLength;
  final double loopHeight;

  @override
  double computeMaxScrollOffset(int childCount) {
    // This returns the scroll offset of the end side of the childCount'th child.
    // In the case of this example, this method is not used, since the grid is
    // infinite. However, if one set an itemCount on the GridView above, this
    // function would be used to determine how far to allow the user to scroll.
    if (childCount == 0 || dimension == 0) {
      return 0;
    }
    return (childCount ~/ loopLength) * loopHeight +
        ((childCount % loopLength) ~/ crossAxisCount) * dimension;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // This returns the position of the index'th tile.
    //
    // The SliverGridGeometry object returned from this method has four
    // properties. For a grid that scrolls down, as in this example, the four
    // properties are equivalent to x,y,width,height. However, since the
    // GridView is direction agnostic, the names used for SliverGridGeometry are
    // also direction-agnostic.
    //
    // Try changing the scrollDirection and reverse properties on the GridView
    // to see how this algorithm works in any direction (and why, therefore, the
    // names are direction-agnostic).
    final int loop = index ~/ loopLength;
    final int loopIndex = index % loopLength;
    if (loopIndex == loopLength - 1) {
      // Full width case.
      return SliverGridGeometry(
        scrollOffset: (loop + 1) * loopHeight - dimension, // "y"
        crossAxisOffset: 0, // "x"
        mainAxisExtent: dimension, // "height"
        crossAxisExtent: crossAxisCount * dimension, // "width"
      );
    }
    // Square case.
    final int rowIndex = loopIndex ~/ crossAxisCount;
    final int columnIndex = loopIndex % crossAxisCount;
    return SliverGridGeometry(
      scrollOffset: (loop * loopHeight) + (rowIndex * dimension), // "y"
      crossAxisOffset: columnIndex * dimension, // "x"
      mainAxisExtent: dimension, // "height"
      crossAxisExtent: dimension, // "width"
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // This returns the first index that is visible for a given scrollOffset.
    //
    // The GridView only asks for the geometry of children that are visible
    // between the scroll offset passed to getMinChildIndexForScrollOffset and
    // the scroll offset passed to getMaxChildIndexForScrollOffset.
    //
    // It is the responsibility of the SliverGridLayout to ensure that
    // getGeometryForChildIndex is consistent with getMinChildIndexForScrollOffset
    // and getMaxChildIndexForScrollOffset.
    //
    // Not every child between the minimum child index and the maximum child
    // index need be visible (some may have scroll offsets that are outside the
    // view; this happens commonly when the grid view places tiles out of
    // order). However, doing this means the grid view is less efficient, as it
    // will do work for children that are not visible. It is preferred that the
    // children are returned in the order that they are laid out.
    final int rows = scrollOffset ~/ dimension;
    final int loops = rows ~/ fullRowPeriod;
    final int extra = rows % fullRowPeriod;
    return loops * loopLength + extra * crossAxisCount;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // (See commentary above.)
    final int rows = scrollOffset ~/ dimension;
    final int loops = rows ~/ fullRowPeriod;
    final int extra = rows % fullRowPeriod;
    final int count = loops * loopLength + extra * crossAxisCount;
    if (extra == fullRowPeriod - 1) {
      return count;
    }
    return count + crossAxisCount - 1;
  }
}