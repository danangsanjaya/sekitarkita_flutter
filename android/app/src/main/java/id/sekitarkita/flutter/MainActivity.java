package id.sekitarkita.flutter;

import android.Manifest;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    //    private final String EXTRA_ADDRESS = "Device_Address";
    private int REQUEST_COARSE = 1;
    final String FLUTTER_SHAREDPREF = "FlutterSharedPreferences";

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "service")
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "start":
                            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                                bluetoothOn(result);
                            } else {
                                forceLocationPermission();
                                Toast.makeText(this, "Layanan gagal dimulai, pastikan anda mengizinkan akses Lokasi dan Bluetooth untuk aplikasi ini.", Toast.LENGTH_SHORT).show();
                                result.success(false);
                            }
                            break;
                        case "stop":
                            stopService(new Intent(this, BlueService.class));
                            Toast.makeText(this, "Layanan dihentikan", Toast.LENGTH_SHORT).show();
                            result.success(true);
                            break;
                    }
                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "setting")
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "device_info":
                            openSetting(Settings.ACTION_DEVICE_INFO_SETTINGS);
                            break;
                        case "wifi":
                            openSetting(Settings.ACTION_WIFI_SETTINGS);
                            break;
                        case "data":
                            openSetting(Settings.ACTION_DATA_ROAMING_SETTINGS);
                            break;
                        case "location":
                            openSetting(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                            break;
                        case "setting":
                            openSetting(Settings.ACTION_APPLICATION_SETTINGS);
                            break;
                        case "bluetooth":
                            openSetting(Settings.ACTION_BLUETOOTH_SETTINGS);
                            break;
                        case "notification":
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                openSetting(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
                            }
                            break;
                        case "security":
                            openSetting(Settings.ACTION_SECURITY_SETTINGS);
                            break;
                        case "sound":
                            openSetting(Settings.ACTION_SOUND_SETTINGS);
                            break;
                        case "main_setting":
                            openSetting(Settings.ACTION_SETTINGS);
                            break;
                        case "date":
                            openSetting(Settings.ACTION_DATE_SETTINGS);
                            break;
                        case "display":
                            openSetting(Settings.ACTION_DISPLAY_SETTINGS);
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    private void openSetting(String target) {
        Intent intent = new Intent(target);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }


    BluetoothAdapter blueAdapter;

    private void bluetoothOn(MethodChannel.Result result) {
        SharedPreferences sharedPreferences = getSharedPreferences(FLUTTER_SHAREDPREF, MODE_PRIVATE);
        if (sharedPreferences.getString("flutter.mac_address", "").length() > 0) {
            blueAdapter = BluetoothAdapter.getDefaultAdapter();
            if (blueAdapter == null) {
                Toast.makeText(this, "Anda tidak memiliki teknologi bluetooth", Toast.LENGTH_SHORT).show();
                result.success(false);
                return;
            }

            if (blueAdapter.isEnabled()) {
                result.success(true);
                startService(new Intent(this, BlueService.class));
                Toast.makeText(this, "Layanan dimulai, mohon untuk tetap waspada.", Toast.LENGTH_SHORT).show();
            } else {
                Intent enableBluetoothIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                int REQUEST_BLUETOOTH = 2;
                startActivityForResult(enableBluetoothIntent, REQUEST_BLUETOOTH);
                Toast.makeText(this, "Layanan gagal dimulai, pastikan anda mengizinkan akses Lokasi dan Bluetooth untuk aplikasi ini.", Toast.LENGTH_SHORT).show();
                result.success(false);
            }
        } else {
            Toast.makeText(this, "Gagal mendapatkan MAC Address yang tersimpan", Toast.LENGTH_SHORT).show();
            result.success(false);
        }
    }

    private void forceLocationPermission() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_COARSE_LOCATION)) {
            new AlertDialog.Builder(this).setTitle("Perhatian").setMessage("Untuk pemindaian lebih akurat, Aplikasi butuh izin akses GPS mu untuk memetakan posisi saat kamu berinteraksi.").setPositiveButton("Mengerti", (dialogInterface, i) -> ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, REQUEST_COARSE)).show();
        } else {
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, REQUEST_COARSE);
        }
    }

}
