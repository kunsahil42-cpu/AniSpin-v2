package com.example.anispin

import android.app.PictureInPictureParams
import android.content.Intent
import android.content.res.Configuration
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity : FlutterActivity() {
    private val PIP_CHANNEL = "com.anispin.video_player/pip"
    private val SHARING_CHANNEL = "com.anispin.app/sharing"
    private var isPlayerActive = false
    private var pipMethodChannel: MethodChannel? = null
    private var sharingMethodChannel: MethodChannel? = null
    private var sharedXmlContent: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null) return
        val action = intent.action
        val data: Uri? = intent.data
        if (Intent.ACTION_VIEW == action && data != null) {
            try {
                contentResolver.openInputStream(data)?.use { inputStream ->
                    BufferedReader(InputStreamReader(inputStream)).use { reader ->
                        val stringBuilder = StringBuilder()
                        var line: String?
                        while (reader.readLine().also { line = it } != null) {
                            stringBuilder.append(line).append("\n")
                        }
                        sharedXmlContent = stringBuilder.toString()
                        sharingMethodChannel?.invokeMethod("onXmlFileReceived", sharedXmlContent)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // PiP channel
        pipMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PIP_CHANNEL)
        pipMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isPipSupported" -> {
                    result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                }
                "enterPip" -> {
                    val entered = enterPipMode()
                    result.success(entered)
                }
                "setPlayerActive" -> {
                    isPlayerActive = call.argument<Boolean>("active") ?: false
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Sharing channel
        sharingMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARING_CHANNEL)
        sharingMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedXmlContent" -> {
                    val content = sharedXmlContent
                    sharedXmlContent = null
                    result.success(content)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun enterPipMode(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val builder = PictureInPictureParams.Builder()
                builder.setAspectRatio(Rational(16, 9))
                return enterPictureInPictureMode(builder.build())
            } catch (e: Exception) {
                return false
            }
        }
        return false
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (isPlayerActive) {
            enterPipMode()
        }
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration?) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        pipMethodChannel?.invokeMethod("onPipChanged", isInPictureInPictureMode)
    }
}
