package com.hyla981020.pdsample;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterMain;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "sample.hyla981020.com/bg";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
      FlutterMain.startInitialization(this);
      super.onCreate(savedInstanceState);
      GeneratedPluginRegistrant.registerWith(this);

      new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
              (call, result) -> {
                  if (call.method.equals("initLocation")) {
                      initLocation();
                  } else if (call.method.equals("stop")) {
                      Log.i("js","stop!");
                      final Intent intent = new Intent(this.getApplication(), Background.class);
                      intent.setAction("Stop");
                      this.getApplication().startService(intent);
                      result.notImplemented();
                  } else {
                      result.notImplemented();
                  }
              });
  }

  private void initLocation() {
    final Intent intent = new Intent(this.getApplication(), Background.class);
      if (Build.VERSION.SDK_INT >= 26) {
          intent.setAction("Start");
          this.getApplication().startForegroundService(intent);
      } else {
          intent.setAction("Start");
          this.getApplication().startService(intent);
      }
  }
}
