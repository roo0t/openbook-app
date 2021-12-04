import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  int? maxLines;
  TextStyle? style;
  TextAlign? textAlign = TextAlign.justify;
  TextDirection? textDirection;
  TextOverflow? overflow;

  ExpandableText(
    this.text, {
    Key? key,
    this.maxLines,
    this.style,
    this.textAlign,
    this.textDirection,
    this.overflow,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isCollapsed = true;

  @override
  void initState() {
    super.initState();

    isCollapsed = true;
  }

  bool didExceedMaxLines(double maxWidth) {
    final TextSpan span = TextSpan(
      text: widget.text,
      style: widget.style,
    );

    // Use a textpainter to determine if it will exceed max lines
    var textPainter = TextPainter(
      maxLines: widget.maxLines,
      textAlign: widget.textAlign ?? TextAlign.justify,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      text: span,
    );

    // trigger it to layout
    textPainter.layout(maxWidth: maxWidth);

    // whether the text overflowed or not
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) => Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: Text(
              widget.text,
              maxLines: isCollapsed ? widget.maxLines : null,
              style: widget.style,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              overflow: widget.overflow,
            ),
          ),
          if (didExceedMaxLines(size.maxWidth))
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      isCollapsed ? "더 보기" : "줄이기",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
