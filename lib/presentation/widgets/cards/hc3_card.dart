import 'package:flutter/material.dart';
import 'package:contextual_cards/data/models/card_model.dart';
import 'package:contextual_cards/data/models/entity.dart';
import 'package:contextual_cards/utils/hex_color.dart';

class HC3Card extends StatefulWidget {
  final CardModel card;
  final Function(CardModel) onRemindLater;
  final Function(CardModel) onDismissNow;
  final bool isScrollable;

  const HC3Card({
    super.key,
    required this.card,
    required this.onRemindLater,
    required this.onDismissNow,
    required this.isScrollable,
  });

  @override
  State<HC3Card> createState() => _HC3CardState();
}

class _HC3CardState extends State<HC3Card> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLongPress() {
    setState(() {
      _isSliding = true;
      _animationController.forward();
    });
  }

  void _onActionSelected(String action) {
    if (action == "remindLater") {
      widget.onRemindLater(widget.card);
    } else if (action == "dismissNow") {
      widget.onDismissNow(widget.card);
    }

    setState(() {
      _isSliding = false;
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _onLongPress,
      child: Stack(
        children: [
          if (_isSliding) _buildActionButtons(),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final double maxOffset = MediaQuery.of(context).size.width * 0.3;
              return Transform.translate(
                offset: Offset(_animationController.value * maxOffset, 0),
                child: _buildCard(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned.fill(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.notifications,
                  text: "Remind Later",
                  color: const Color(0xFFF7F6F3),
                  onTap: () => _onActionSelected("remindLater"),
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  icon: Icons.close_rounded,
                  text: "Dismiss Now",
                  color: const Color(0xFFF7F6F3),
                  onTap: () => _onActionSelected("dismissNow"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = widget.isScrollable
            ? MediaQuery.of(context).size.width - 50
            : constraints.maxWidth;
        final double height = widget.card.bgImage?.aspectRatio != null
            ? width / widget.card.bgImage!.aspectRatio!
            : 420;

        return Container(
          margin: widget.isScrollable
              ? const EdgeInsets.symmetric(vertical: 5)
              : const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          height: widget.isScrollable ? 420 : height,
          width: width,
          decoration: BoxDecoration(
            color: widget.card.bgColor ?? Colors.grey[400],
            borderRadius: BorderRadius.circular(12),
            image: widget.card.bgImage != null
                ? DecorationImage(
                    image: NetworkImage(widget.card.bgImage!.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 16, 16, 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.card.formattedTitle != null)
                  _buildFormattedText(
                    widget.card.formattedTitle!.text,
                    widget.card.formattedTitle!.entities,
                    _getTextAlign(widget.card.formattedTitle!.align),
                  ),
                const SizedBox(height: 15),
                if (widget.card.formattedDescription != null)
                  _buildFormattedText(
                    widget.card.formattedDescription!.text,
                    widget.card.formattedDescription!.entities,
                    _getTextAlign(widget.card.formattedDescription!.align),
                  ),
                if (widget.card.cta != null && widget.card.cta!.isNotEmpty)
                  const SizedBox(height: 15),
                if (widget.card.cta != null && widget.card.cta!.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      // Handle CTA action
                      print("CTA Clicked: ${widget.card.cta![0].url}");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      backgroundColor:
                          HexColor.fromHex(widget.card.cta![0].bgColor) ??
                              Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      widget.card.cta![0].text,
                      style: TextStyle(
                          color:
                              HexColor.fromHex(widget.card.cta![0].textColor) ??
                                  Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormattedText(
      String text, List<Entity> entities, TextAlign align) {
    final List<TextSpan> spans = [];
    final List<String> parts = text.split('{}');
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ));
      if (i < entities.length) {
        final entity = entities[i];
        spans.add(TextSpan(
          text: entity.text,
          style: TextStyle(
            color: HexColor.fromHex(entity.color) ?? Colors.black,
            fontSize: entity.fontSize ?? 16,
            fontStyle: entity.fontStyle == "italic"
                ? FontStyle.italic
                : FontStyle.normal,
            decoration: entity.fontStyle == "underline"
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ));
      }
    }
    return Text.rich(
      TextSpan(children: spans),
      textAlign: align,
    );
  }

  TextAlign _getTextAlign(String? align) {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}
