package me.albemala.native_video_player

import io.flutter.embedding.engine.plugins.FlutterPlugin

class NativeVideoPlayerPlugin : FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val factory = NativeVideoPlayerViewFactory(binding.binaryMessenger)
        binding.platformViewRegistry.registerViewFactory(NativeVideoPlayerViewFactory.id, factory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
