import 'package:flutter/material.dart';
import 'package:stacked_list_carousel/stacked_list_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SwipeAnimationScreenView(),
    );
  }
}

class CustomModel {
  final String image;

  CustomModel(this.image);
}

class SwipeAnimationScreenView extends StatefulWidget {
  const SwipeAnimationScreenView({super.key});

  @override
  State<SwipeAnimationScreenView> createState() => _SwipeAnimationScreenViewState();
}

class _SwipeAnimationScreenViewState extends State<SwipeAnimationScreenView> with TickerProviderStateMixin {
  List<CustomModel> items = [
    CustomModel("https://picsum.photos/400/400?random=2"),
    CustomModel("https://picsum.photos/400/400?random=4"),
    CustomModel("https://picsum.photos/400/400?random=5"),
    CustomModel("https://picsum.photos/400/400?random=6"),
    CustomModel("https://picsum.photos/400/400?random=7"),
    CustomModel("https://picsum.photos/400/400?random=9"),
    CustomModel("https://picsum.photos/400/400?random=8"),
    CustomModel("https://picsum.photos/400/400?random=2"),
    CustomModel("https://picsum.photos/400/400?random=4"),
    CustomModel("https://picsum.photos/400/400?random=5"),
    CustomModel("https://picsum.photos/400/400?random=6"),
    CustomModel("https://picsum.photos/400/400?random=7"),
    CustomModel("https://picsum.photos/400/400?random=9"),
    CustomModel("https://picsum.photos/400/400?random=8"),
    CustomModel("https://picsum.photos/400/400?random=2"),
    CustomModel("https://picsum.photos/400/400?random=4"),
    CustomModel("https://picsum.photos/400/400?random=5"),
    CustomModel("https://picsum.photos/400/400?random=6"),
    CustomModel("https://picsum.photos/400/400?random=7"),
    CustomModel("https://picsum.photos/400/400?random=9"),
    CustomModel("https://picsum.photos/400/400?random=8"),
  ];

  final StackedListController<CustomModel> _stackedListController = StackedListController();

  late final AnimationController _leftAnimationController;
  late final Animation _leftAnimation;
  bool isLeftAnimated = false;

  late final AnimationController _rightAnimationController;
  late final Animation _rightAnimation;
  bool isRightAnimated = false;

  @override
  void initState() {
    ///Left animation handle
    _leftAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _leftAnimation = Tween(begin: 0.0, end: 40.0).animate(_leftAnimationController)
      ..addListener(() {
        setState(() {});
      });
    _leftAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isLeftAnimated = false;
        _leftAnimationController.stop();
        _leftAnimationController.reset();
        setState(() {});
      }
    });

    ///Right animation handle
    _rightAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _rightAnimation = Tween(begin: 0.0, end: 40.0).animate(_rightAnimationController)
      ..addListener(() {
        setState(() {});
      });
    _rightAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isRightAnimated = false;
        _rightAnimationController.stop();
        _rightAnimationController.reset();
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Row(),
            const SizedBox(height: 11),
            Container(
              width: 95,
              height: 22,
              decoration: ShapeDecoration(
                color: const Color(0xFF44AB87),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Center(
                child: Text(
                  "Open for swipe",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Night party at the Atlantis',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              '20:00 mins left',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: StackedListCarousel<CustomModel>(
                behavior: CarouselBehavior.consume,
                items: items,
                controller: _stackedListController,
                maxDisplayedItemCount: 4,
                itemGapHeightFactor: 0.02,
                outermostCardHeightFactor: 0.85,
                transitionCurve: Curves.bounceInOut,
                emptyBuilder: (_) => const Center(child: Text("No items found")),
                outermostCardAnimationDuration: const Duration(milliseconds: 650),
                cardBuilder: (context, item, size) {
                  return CardSwipeItemView(image: item.image);
                },
                cardSwipedCallback: (item, direction) {
                  print("cardSwipedCallback :: [$direction]");
                  if (direction == SwipeDirection.bottomLeft || direction == SwipeDirection.topLeft) {
                    isLeftAnimated = true;
                    _leftAnimationController.forward();
                    setState(() {});
                  }
                  if (direction == SwipeDirection.bottomRight || direction == SwipeDirection.topRight) {
                    isRightAnimated = true;
                    _rightAnimationController.forward();
                    setState(() {});
                  }
                },
              ),
            ),

            ///48
            BottomView(
              onLeftTap: () {
                _stackedListController.changeOrders();
                isLeftAnimated = true;
                _leftAnimationController.forward();
                setState(() {});
              },
              onRightTap: () {
                isRightAnimated = true;
                _rightAnimationController.forward();
                _stackedListController.changeOrders(withOutermostDiscardEffect: true);
                setState(() {});
              },
              isLeftAnimated: isLeftAnimated,
              leftAnimation: _leftAnimation,
              leftAnimationController: _leftAnimationController,
              isRightAnimated: isRightAnimated,
              rightAnimation: _rightAnimation,
              rightAnimationController: _rightAnimationController,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class CardSwipeItemView extends StatelessWidget {
  const CardSwipeItemView({
    super.key,
    this.image = "",
    this.isButtonShow = false,
  });

  final String image;
  final bool isButtonShow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF19151F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  image,
                  height: 344,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text(
                  'Sarah Sheikh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '2.4 ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Punctuality',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 17),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomView extends StatelessWidget {
  const BottomView({
    super.key,
    this.onLeftTap,
    this.onRightTap,
    required this.isLeftAnimated,
    required this.leftAnimation,
    required this.leftAnimationController,
    required this.isRightAnimated,
    required this.rightAnimation,
    required this.rightAnimationController,
  });

  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  final bool isLeftAnimated;
  final Animation leftAnimation;
  final AnimationController leftAnimationController;

  final bool isRightAnimated;
  final Animation rightAnimation;
  final AnimationController rightAnimationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 23),
        const Text(
          '3 / 400',
          style: TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleButtonView(
              onTap: onLeftTap,
              isAnimated: isLeftAnimated,
              animation: leftAnimation,
              animationController: leftAnimationController,
              child: const Icon(Icons.cancel_outlined),
            ),
            const SizedBox(width: 59),
            CircleButtonView(
              onTap: onRightTap,
              isAnimated: isRightAnimated,
              animation: rightAnimation,
              animationController: rightAnimationController,
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ],
    );
  }
}

class CircleButtonView extends StatelessWidget {
  const CircleButtonView({
    super.key,
    this.onTap,
    required this.child,
    required this.isAnimated,
    required this.animation,
    required this.animationController,
    this.duration = const Duration(seconds: 1),
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isAnimated;
  final Animation animation;
  final AnimationController animationController;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: AnimatedOpacity(
              duration: duration,
              opacity: isAnimated ? 1.0 : 0.0,
              child: AnimatedContainer(
                duration: duration,
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: animation.value,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: duration,
              width: (60.0 + animation.value + 3),
              height: (60.0 + animation.value + 3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
