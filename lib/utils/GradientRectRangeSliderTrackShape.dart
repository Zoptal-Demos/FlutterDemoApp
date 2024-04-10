import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientRectRangeSliderTrackShape extends RangeSliderTrackShape {
  const GradientRectRangeSliderTrackShape({
    this.gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(0, 170, 79, 1),
        Color.fromRGBO(3, 160, 85, 1),
        Color.fromRGBO(13, 133, 103, 1),
        Color.fromRGBO(27, 90, 131, 1),
        Color.fromRGBO(38, 59, 151, 1),
      ],
    ),
    this.darkenInactive = true,
  });

  final LinearGradient gradient;
  final bool darkenInactive;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(
    sliderTheme.overlayShape != null,
    'sliderTheme.overlayShape is required',
    );
    assert(
    sliderTheme.trackHeight != null,
    'sliderTheme.trackHeight is required',
    );

    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft + parentBox.size.width - overlayWidth;
    final double trackBottom = trackTop + trackHeight;
    return Rect.fromLTRB(
      math.min(trackLeft, trackRight),
      trackTop,
      math.max(trackLeft, trackRight),
      trackBottom,
    );
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset startThumbCenter,
        required Offset endThumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        required TextDirection textDirection,
        double additionalActiveTrackHeight = 2,
      }) {
    assert(
    sliderTheme.disabledActiveTrackColor != null,
    'sliderTheme.disabledActiveTrackColor is required',
    );
    assert(
    sliderTheme.disabledInactiveTrackColor != null,
    'sliderTheme.disabledInactiveTrackColor is required',
    );
    assert(
    sliderTheme.activeTrackColor != null,
    'sliderTheme.activeTrackColor is required',
    );
    assert(
    sliderTheme.inactiveTrackColor != null,
    'sliderTheme.inactiveTrackColor is required',
    );
    assert(
    sliderTheme.rangeThumbShape != null,
    'sliderTheme.rangeThumbShape iss required',
    );
    assert(
    sliderTheme.trackHeight != null && sliderTheme.trackHeight! > 0,
    'sliderTheme.trackHeight != null and sliderTheme.trackHeight! > 0'
        'are required',
    );

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = darkenInactive
        ? ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    )
        : activeTrackColorTween;
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Offset leftThumbOffset;
    final Offset rightThumbOffset;
    switch (textDirection) {
      case TextDirection.ltr:
        leftThumbOffset = startThumbCenter;
        rightThumbOffset = endThumbCenter;
        break;
      case TextDirection.rtl:
        leftThumbOffset = endThumbCenter;
        rightThumbOffset = startThumbCenter;
        break;
    }
    final Size thumbSize = sliderTheme.rangeThumbShape!
        .getPreferredSize(
      isEnabled,
      isDiscrete,
    );
    final double thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        leftThumbOffset.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      inactivePaint,
    );
    context.canvas.drawRect(
      Rect.fromLTRB(
        rightThumbOffset.dx,
        trackRect.top - (additionalActiveTrackHeight / 2),
        leftThumbOffset.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
      ),
      activePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rightThumbOffset.dx,
        trackRect.bottom,
        trackRect.right,
        trackRect.top,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
  }
}

class RoundRangeSliderThumbShapeWithGradient extends SliderComponentShape {
  final double thumbRadius;
  final LinearGradient gradient;

  RoundRangeSliderThumbShapeWithGradient({
    this.thumbRadius = 10.0,
    this.gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 0, 0, 1),
        Color.fromRGBO(255, 255, 0, 1),
      ],
    ),
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double>? activationAnimation,
        Animation<double>? enableAnimation,
        bool? isDiscrete,
        TextPainter? labelPainter,
        RenderBox? parentBox,
        SliderThemeData? sliderTheme,
        TextDirection? textDirection,
        double? value,
        double? textScaleFactor,
        Size? sizeWithOverflow,
        double? scale,
      }) {
    final Canvas canvas = context.canvas;

    final double radius = thumbRadius * (1 + (scale ?? 1.0));
    final Paint paint = Paint();
    paint.shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }
}