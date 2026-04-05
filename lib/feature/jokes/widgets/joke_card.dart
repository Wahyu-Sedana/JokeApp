import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

import '../../../core/models/api/joke_model.dart';
import 'safe_content_wrapper.dart';

class JokeCard extends StatefulWidget {
  const JokeCard({super.key, required this.joke});

  final JokeModel joke;

  @override
  State<JokeCard> createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSingle = widget.joke.type == 'single';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTapDown: (_) => _tapController.forward(),
        onTapUp: (_) => _tapController.reverse(),
        onTapCancel: () => _tapController.reverse(),
        child: AnimatedBuilder(
          animation: _tapAnimation,
          builder: (context, _) => Transform.scale(
            scale: _tapAnimation.value,
            child: SafeContentWrapper(
              isSafe: widget.joke.safe,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _TypeLabel(isSingle: isSingle),
                        const Spacer(),
                        _ShareButton(joke: widget.joke),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _JokeContent(joke: widget.joke, isSingle: isSingle),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeLabel extends StatelessWidget {
  const _TypeLabel({required this.isSingle});

  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isSingle ? 'One-liner' : 'Two-part',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _JokeContent extends StatelessWidget {
  const _JokeContent({required this.joke, required this.isSingle});

  final JokeModel joke;
  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    if (isSingle) {
      return Text(
        joke.joke ?? '',
        style: TextStyle(fontSize: 15, height: 1.65, color: textColor),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          joke.setup ?? '',
          style: TextStyle(
            fontSize: 15,
            height: 1.65,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            joke.delivery ?? '',
            style: TextStyle(
              fontSize: 15,
              height: 1.65,
              fontStyle: FontStyle.italic,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.joke});

  final JokeModel joke;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _share(joke),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.share_rounded,
          size: 17,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _share(JokeModel joke) {
    final text = joke.type == 'single'
        ? joke.joke ?? ''
        : '${joke.setup ?? ''}\n\n${joke.delivery ?? ''}';

    if (text.isNotEmpty) {
      SharePlus.instance.share(
        ShareParams(text: text, subject: 'Check out this joke!'),
      );
    }
  }
}
