import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageCurlShader extends StatefulWidget {
  final Widget child;
  final double animationAmount;

  const PageCurlShader({super.key, required this.child, this.animationAmount = 0.5,});

  @override
  State<PageCurlShader> createState() => _PageCurlShaderState();
}

class _PageCurlShaderState extends State<PageCurlShader> {
  late ui.FragmentProgram program;
  ui.FragmentShader? shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  Future<void> _loadShader() async {
    program = await ui.FragmentProgram.fromAsset('shaders/page_curl.frag');
    setState(() {
      shader = program.fragmentShader();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return widget.child;
    }

    return ShaderMask(
      shaderCallback: (bounds) {
        shader!
          ..setFloat(0, bounds.width)
          ..setFloat(1, bounds.height)
          ..setFloat(2, widget.animationAmount); // animation amount (0.0 to 1.0)
        return shader!;
      },
      blendMode: BlendMode.srcATop,
      child: widget.child,
    );
  }
}
