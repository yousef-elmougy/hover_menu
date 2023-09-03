import 'package:flutter/material.dart';

class HoverMenuWidget<T> extends StatefulWidget {
  final Widget? dropDownItem;
  final double? width;
  final Widget? Function(int index)? menuItemBuilder;
  final List<String> texts;
  final TextStyle? textStyle;
  final T? menuTitle;
  final Widget? icon;
  final void Function()? onMenuTap;
  final void Function(int index)? onItemTap;

  const HoverMenuWidget({
    super.key,
    this.dropDownItem,
    this.menuItemBuilder,
    this.width,
    this.texts = const [],
    this.textStyle,
    this.menuTitle,
    this.icon,
    this.onMenuTap,
    this.onItemTap,
  });

  @override
  State<HoverMenuWidget<T>> createState() => _HoverMenuWidgetState<T>();
}

class _HoverMenuWidgetState<T> extends State<HoverMenuWidget<T>> {
  OverlayEntry? _overlayEntry;
  final _focusNode = FocusNode();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => onEnter(),
        onExit: (_) => onExit(),
        child: TextButton(
          focusNode: _focusNode,
          onPressed: widget.onMenuTap ?? () {},
          child: widget.dropDownItem ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      '${widget.menuTitle}',
                      style: widget.textStyle ??
                          const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  if (widget.texts.isNotEmpty)
                    widget.icon ??
                        const Icon(
                          Icons.expand_more,
                          color: Colors.black,
                          size: 16,
                        ),
                ],
              ),
        ),
      );

  void onFocusChanged() {
    if (_focusNode.hasFocus) {
      _overlayEntry = createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      removeOverlay();
    }
  }

  void removeOverlay() {
    _focusNode.unfocus();
    _isHovered = false;
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry!.dispose();
      _overlayEntry = null;
    }
  }

  void onExit() {
    if (_isHovered) {
      setState(() => _isHovered = false);
      _focusNode.unfocus();
    }
  }

  void onEnter() {
    if (!_isHovered) {
      setState(() => _isHovered = true);
      _focusNode.requestFocus();
    }
  }

  OverlayEntry createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: widget.width ?? 200,
        child: MouseRegion(
          onEnter: (_) => onEnter(),
          onExit: (_) => onExit(),
          child: buildOverlayWidget(),
        ),
      ),
    );
  }

  Material buildOverlayWidget() => Material(
        elevation: 5,
        shadowColor: Colors.black,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: List.generate(
            widget.texts.length,
            (index) => ListTile(
              mouseCursor: SystemMouseCursors.click,
              onTap: () {
                removeOverlay();
                widget.onItemTap?.call(index);
              },
              title: widget.menuItemBuilder?.call(index) ??
                  Text(
                    widget.texts[index],
                    style: const TextStyle(fontSize: 16),
                  ),
            ),
          ),
        ),
      );
}
