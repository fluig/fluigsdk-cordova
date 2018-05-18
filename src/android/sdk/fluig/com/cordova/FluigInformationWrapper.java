package sdk.fluig.com.cordova;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import sdk.fluig.com.bll.core.BllConfiguration;
import sdk.fluig.com.core.configuration.SDKGlobalConfiguration;
import sdk.fluig.com.datasource.model.core.Server;
import sdk.fluig.com.datasource.model.core.Session;
import sdk.fluig.com.datasource.model.core.User;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.List;

public final class FluigInformationWrapper extends CordovaPlugin {

    private static final String DATE_PATTERN = "[yyyyMMdd][yyyy-MM-dd][yyyy-DDD]['T'[HHmmss][HHmm][HH:mm:ss][HH:mm][.SSSSSSSSS][.SSSSSS][.SSS][.SS][.S]][z]";

    private Gson gson;

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        
        gson = new GsonBuilder().setDateFormat(DATE_PATTERN).create();
    }

    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        switch (action) {
            case "getJwtToken":
                return getJwtToken(callbackContext);
            case "getLoggedUser":
                return getLoggedUser(callbackContext);
            case "getLoggedServer":
                return getLoggedServer(callbackContext);
            case "getSessions":
                return getSessions(callbackContext);
            default:
                break;
        }

        callbackContext.error("Unsupported method for login information plugin.");
        return false;
    }
    
    private boolean getJwtToken(final CallbackContext callbackContext) {
        try {
            String jwtToken = SDKGlobalConfiguration.getJwtToken();
            if (jwtToken == null) {
                throw new NullPointerException();
            }

            String json = "{\"jwtToken\":\"" + jwtToken + "\"}";
            return convertStringInformation(json, callbackContext);
            
        } catch (Exception e) {
            callbackContext.error("Unable to retrieve the JWT token.");
            return false;
        }
    }
    
    private boolean getLoggedUser(final CallbackContext callbackContext) {
        User user = BllConfiguration.getLoggedUser();
        if (user == null) {
            callbackContext.error("Unable to find the User::class information.");
            return false;
        }

        String json = gson.toJson(user, User.class);
        return convertStringInformation(json, callbackContext);
    }

    private boolean getLoggedServer(final CallbackContext callbackContext) {
        Server server = BllConfiguration.getLoggedServer();
        if (server == null) {
            callbackContext.error("Unable to find the Server::class information.");
            return false;
        }

        String json = gson.toJson(server, Server.class);
        return convertStringInformation(json, callbackContext);
    }

    private boolean getSessions(final CallbackContext callbackContext) {
        List<Session> sessions = BllConfiguration.getSessions();
        if (sessions == null || sessions.isEmpty()) {
            callbackContext.error("Unable to find any valid Session:class information.");
        }

        Type type = new TypeToken<List<Session>>() {}.getType();
        String json = gson.toJson(sessions, type);
        return convertStringInformation(json, callbackContext);
    }

    private boolean convertStringInformation(String json, final CallbackContext callbackContext) {
        if (json == null) {
            callbackContext.error("Unable to convert retrieved information to String::class.");
            return false;
        }

        try {
            JSONObject jsonObject = new JSONObject(json);
            callbackContext.success(jsonObject);
            return true;

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Unable to convert from String::class to JSONObject::class.");
            return false;
        }
    }
}
