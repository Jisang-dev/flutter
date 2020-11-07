package com.hyla981020.pdsample;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

public class Background extends Service {
//    private LocationListener mLocationListener;
//    private LocationManager mLocationManager;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent.getAction().equals("Start")) {
            Log.i("js", "Received Start Foreground Intent ");
            startForeground((int) System.currentTimeMillis() % 10000, getNotification());
            // your start service code
        }
        else if (intent.getAction().equals("Stop")) {
            Log.i("js", "Received Stop Foreground Intent");
            //your end servce code
            stopForeground(true);
            stopSelf();
        }
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    private Notification getNotification() {
        if (Build.VERSION.SDK_INT >= 26) {
            NotificationChannel channel = new NotificationChannel("channel_01", "My Channel", NotificationManager.IMPORTANCE_DEFAULT);

            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);

            Notification.Builder builder = new Notification.Builder(getApplicationContext(), "channel_01").setAutoCancel(false).setContentTitle("백그라운드에서 위치 데이터 사용중").setContentText("백그라운드에서 위치 데이터 사용중입니다.").setOngoing(true);

            return builder.build();
        } else {
            Notification.Builder builder = new Notification.Builder(getApplicationContext()).setAutoCancel(false).setContentTitle("백그라운드에서 위치 데이터 사용중").setContentText("백그라운드에서 위치 데이터 사용중입니다.").setOngoing(true);

            return builder.build();
        }
    }

}
