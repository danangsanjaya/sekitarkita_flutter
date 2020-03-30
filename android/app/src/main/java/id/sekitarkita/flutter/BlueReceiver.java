package id.sekitarkita.flutter;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.os.Looper;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import static android.content.ContentValues.TAG;

public class BlueReceiver extends BroadcastReceiver {
    FusedLocationProviderClient fusedLocationProviderClient;
    final String STORE_DEV_API = "https://sekitarkita.id/api/store-device";
    final String FLUTTER_SHAREDPREF = "FlutterSharedPreferences";

    ArrayList<String> coveredDevices = new ArrayList<>();

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        assert action != null;
        SharedPreferences sharedPreferences = context.getSharedPreferences(FLUTTER_SHAREDPREF, Context.MODE_PRIVATE);
        switch (action) {
            case BluetoothDevice.ACTION_FOUND:
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context);
                fusedLocationProviderClient.getLastLocation().addOnCompleteListener(task -> {
                    Location loc = task.getResult();
                    if (loc == null) {
                        requestNewLocationData(context);
                    } else {
                        JSONObject body = new JSONObject();
                        SharedPreferences.Editor sprefEdit = sharedPreferences.edit();
                        sprefEdit.putLong("flutter.latitude", Double.doubleToRawLongBits(loc.getLatitude()));
                        sprefEdit.putLong("flutter.longitude", Double.doubleToRawLongBits(loc.getLongitude()));
                        sprefEdit.apply();
                        sprefEdit.commit();

                        if (coveredDevices.contains(device.getAddress())) {
                            return;
                        }

                        try {
                            body.put("device_id", sharedPreferences.getString("flutter.mac_address", "02:00:00:00:00:00"));
                            body.put("nearby_device", device.getAddress());
                            body.put("device_name", device.getName());
                            body.put("latitude", loc.getLatitude());
                            body.put("longitude", loc.getLongitude());
                            Volley.newRequestQueue(context)
                                    .add(new JsonObjectRequest(Request.Method.POST, STORE_DEV_API, body, response -> {
                                        coveredDevices.add(device.getAddress());
                                    }, null));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });
                break;
            case BluetoothAdapter.ACTION_DISCOVERY_FINISHED:
                Log.d(TAG, "Discovery Finished");
                break;
            case BluetoothAdapter.ACTION_STATE_CHANGED:
                Log.d(TAG, "State Changed");
                break;
        }
    }


    LocationCallback mLocationCallback(Context context) {
        return new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                SharedPreferences sharedPreferences = context.getSharedPreferences(FLUTTER_SHAREDPREF, Context.MODE_PRIVATE);
                Location loc = locationResult.getLastLocation();
                SharedPreferences.Editor sprefEdit = sharedPreferences.edit();
                sprefEdit.putLong("flutter.latitude", Double.doubleToRawLongBits(loc.getLatitude()));
                sprefEdit.putLong("flutter.longitude", Double.doubleToRawLongBits(loc.getLongitude()));
                sprefEdit.apply();
                sprefEdit.commit();
                super.onLocationResult(locationResult);
            }
        };
    }

    @SuppressLint("MissingPermission")
    private void requestNewLocationData(Context context) {
        LocationRequest mLocationRequest = LocationRequest.create();
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        mLocationRequest.setInterval(0);
        mLocationRequest.setFastestInterval(0);
        mLocationRequest.setNumUpdates(1);
        this.fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context);
        fusedLocationProviderClient.requestLocationUpdates(
                mLocationRequest, mLocationCallback(context), Looper.myLooper()
        );
    }
}
