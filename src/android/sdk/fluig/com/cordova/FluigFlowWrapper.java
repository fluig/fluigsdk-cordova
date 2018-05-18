package sdk.fluig.com.cordova;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import sdk.fluig.com.bll.core.login.LoginFlow;
import sdk.fluig.com.core.cache.Cacheable;
import sdk.fluig.com.core.configuration.ConfigurationUtils;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.Date;

public class FluigFlowWrapper extends CordovaPlugin {
    private static final String TAG = "FluigSdkCordova";

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        Log.d(TAG, "Initializing MyCordovaPlugin");

        try {
            ConfigurationUtils.initConfiguration(cordova.getContext(), null);
        } catch (Exception ex){
            ex.printStackTrace();
        }
    }

    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals("login")) {
            return login(args, callbackContext);
        }

        callbackContext.error("Unsupported method for flows plugin.");
        return false;
    }

    private boolean login(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Context context = cordova.getContext();
        if (context == null) {
            callbackContext.error("Unable to start login flow.");
            return false;
        }

        BroadcastReceiver receiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                callbackContext.success();
            }
        };

        IntentFilter filter = new IntentFilter();
        filter.addAction(LoginFlow.ACTION_DID_LOGIN);
        context.registerReceiver(receiver, filter);

        LoginFlow flow = new LoginFlow(context);
        flow.start();

        return true;
    }
}
