import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/models/api/joke_model.dart';
import '../../filter/states/joke_state.dart';
import '../../filter/screens/filter_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _listController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _listController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background with particles
          _buildAnimatedBackground(),

          // Main content
          RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(jokeProvider.future);
              _listController.forward(from: 0.0);
            },
            color: const Color.fromRGBO(138, 43, 226, 1),
            backgroundColor: Colors.white,
            child: CustomScrollView(
              slivers: [
                _buildAnimatedAppBar(),
                _buildJokesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color.fromRGBO(78, 11, 62, 1),
                  const Color.fromRGBO(138, 43, 226, 1),
                  (sin(_backgroundAnimation.value * 2 * pi) + 1) / 4 + 0.3,
                )!,
                const Color(0xFF0D0D0F),
                Color.lerp(
                  const Color.fromRGBO(75, 0, 130, 0.3),
                  const Color.fromRGBO(138, 43, 226, 0.2),
                  (cos(_backgroundAnimation.value * 2 * pi) + 1) / 4 + 0.1,
                )!,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children:
                List.generate(15, (index) => _buildFloatingParticle(index)),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = Random(index);
    final size = random.nextDouble() * 4 + 2;
    final speed = random.nextDouble() * 0.3 + 0.1;
    final offset = random.nextDouble() * 2 * pi;

    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        final x = screenSize.width * 0.1 +
            (screenSize.width * 0.8) * random.nextDouble() +
            sin(_backgroundAnimation.value * 2 * pi * speed + offset) * 30;
        final y = screenSize.height * 0.1 +
            (screenSize.height * 0.8) * random.nextDouble() +
            cos(_backgroundAnimation.value * 2 * pi * speed + offset) * 30;

        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity:
                (sin(_backgroundAnimation.value * 2 * pi * speed + offset) +
                            1) /
                        6 +
                    0.1,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(138, 43, 226, 0.3),
                    blurRadius: size * 2,
                    spreadRadius: size * 0.5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromRGBO(78, 11, 62, 0.9),
              const Color.fromRGBO(78, 11, 62, 0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          title: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + sin(_backgroundAnimation.value * 2 * pi) * 0.02,
                child: Text(
                  'Joke Collection',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          centerTitle: true,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierLabel: FilterScreen.routeName,
                builder: (context) => const FilterScreen(),
              );
            },
            icon: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 20,
            ),
            tooltip: 'Filter',
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildJokesList() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: Consumer(
        builder: (context, ref, _) {
          final asyncJokes = ref.watch(jokeProvider);

          return asyncJokes.when(
            data: (jokesModel) {
              // Trigger list animation when data loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _listController.forward(from: 0.0);
              });

              return _buildAnimatedJokesList(jokesModel.jokes);
            },
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: _buildErrorState(() => ref.invalidate(jokeProvider)),
            ),
            loading: () => const SliverToBoxAdapter(
              child: _LoadingState(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedJokesList(List<JokeModel> jokes) {
    if (jokes.isEmpty) {
      return const SliverToBoxAdapter(child: _EmptyState());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AnimatedBuilder(
            animation: _listController,
            builder: (context, child) {
              final animationValue = Curves.easeOutCubic.transform(
                (_listController.value - (index * 0.1)).clamp(0.0, 1.0),
              );

              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: AnimatedJokeCard(
                    joke: jokes[index],
                    delay: Duration(milliseconds: index * 100),
                  ),
                ),
              );
            },
          );
        },
        childCount: jokes.length,
      ),
    );
  }

  Widget _buildErrorState(VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t load the jokes right now',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(138, 43, 226, 1),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatefulWidget {
  const _LoadingState();

  @override
  State<_LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<_LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color.fromRGBO(138, 43, 226, 1),
                          const Color.fromRGBO(78, 11, 62, 1),
                        ],
                      ),
                    ),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Text(
                    'Loading amazing jokes...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Icon(
                Icons.sentiment_neutral_rounded,
                size: 48,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No jokes found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedJokeCard extends StatefulWidget {
  const AnimatedJokeCard({
    super.key,
    required this.joke,
    required this.delay,
  });

  final JokeModel joke;
  final Duration delay;

  @override
  State<AnimatedJokeCard> createState() => _AnimatedJokeCardState();
}

class _AnimatedJokeCardState extends State<AnimatedJokeCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _tapAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _tapAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSingleJoke = widget.joke.type == "single";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: GestureDetector(
          onTapDown: (_) => _tapController.forward(),
          onTapUp: (_) => _tapController.reverse(),
          onTapCancel: () => _tapController.reverse(),
          child: AnimatedBuilder(
            animation: Listenable.merge(
                [_hoverAnimation, _tapAnimation, _glowAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _hoverAnimation.value * _tapAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(138, 43, 226, 1)
                            .withOpacity(0.1 + _glowAnimation.value * 0.2),
                        blurRadius: 10 + _glowAnimation.value * 10,
                        spreadRadius: _glowAnimation.value * 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SafeContentWrapper(
                    isSafe: widget.joke.safe,
                    child: Card(
                      elevation: 0,
                      color: const Color(0xFF1A1A1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: const Color.fromRGBO(138, 43, 226, 1)
                              .withOpacity(0.2 + _glowAnimation.value * 0.3),
                          width: 1 + _glowAnimation.value,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _JokeTypeChip(isSingle: isSingleJoke),
                                const Spacer(),
                                _ShareButton(joke: widget.joke),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _JokeContent(
                                joke: widget.joke, isSingle: isSingleJoke),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _JokeTypeChip extends StatelessWidget {
  const _JokeTypeChip({required this.isSingle});

  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSingle
              ? [
                  Colors.orange.withOpacity(0.8),
                  Colors.deepOrange.withOpacity(0.6)
                ]
              : [
                  const Color.fromRGBO(138, 43, 226, 0.8),
                  const Color.fromRGBO(78, 11, 62, 0.6)
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isSingle
                    ? Colors.orange
                    : const Color.fromRGBO(138, 43, 226, 1))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        isSingle ? 'One-liner' : 'Two-part',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _JokeContent extends StatelessWidget {
  const _JokeContent({
    required this.joke,
    required this.isSingle,
  });

  final JokeModel joke;
  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    if (isSingle) {
      return Text(
        joke.joke ?? '',
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.white,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          joke.setup ?? '',
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(138, 43, 226, 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(138, 43, 226, 0.3),
            ),
          ),
          child: Text(
            joke.delivery ?? '',
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(138, 43, 226, 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShareButton extends StatefulWidget {
  const _ShareButton({required this.joke});

  final JokeModel joke;

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _shareJoke();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.share_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          );
        },
      ),
    );
  }

  void _shareJoke() {
    final String jokeText;

    if (widget.joke.type == "single") {
      jokeText = widget.joke.joke ?? '';
    } else {
      jokeText = '${widget.joke.setup ?? ''}\n\n${widget.joke.delivery ?? ''}';
    }

    if (jokeText.isNotEmpty) {
      Share.share(jokeText, subject: 'Check out this joke!');
    }
  }
}

class SafeContentWrapper extends StatefulWidget {
  const SafeContentWrapper({
    super.key,
    required this.isSafe,
    required this.child,
  });

  final bool isSafe;
  final Widget child;

  @override
  State<SafeContentWrapper> createState() => _SafeContentWrapperState();
}

class _SafeContentWrapperState extends State<SafeContentWrapper> {
  bool _showContent = true;

  @override
  void initState() {
    super.initState();
    _showContent = widget.isSafe;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSafe) {
      return widget.child;
    }

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: _showContent
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
              : ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: widget.child,
        ),
        if (!_showContent)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1E).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility_off_rounded,
                      size: 32,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explicit Content',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _showContent = true),
                      icon: const Icon(Icons.visibility_rounded),
                      label: const Text('Show Content'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(138, 43, 226, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
