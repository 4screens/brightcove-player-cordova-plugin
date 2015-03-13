package org.nopattern.cordova.brightcoveplayer;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Patterns;
import android.net.Uri;

public class BrightcovePlayerPlugin extends CordovaPlugin {
  protected static final String LOG_TAG = "[BrightcovePlayerPlugin]";

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("playByUrl")) {
      String url = args.getString(0);
      this.playByUrl(url, callbackContext);
      return true;
    } else if (action.equals("playById")) {
      String id = args.getString(0);
      this.playById(id, callbackContext);
      return true;
    }
    return false;
  }

  private void playByUrl(String url, CallbackContext callbackContext) {
    if (this.urlIsValid(url)) {
      callbackContext.success(LOG_TAG + " Playing now: " + url);
    } else {
      callbackContext.error(LOG_TAG + " URL is not valid or empty!");
    }
  }

  private void playById(String id, CallbackContext callbackContext) {
    if (id != null && id.length() > 0){
      callbackContext.success(LOG_TAG + " Playing now: " + id);
    } else{
      callbackContext.error(LOG_TAG + " Empty video ID!");
    }
  }

  private boolean urlIsValid(String url) {
    return Patterns.WEB_URL.matcher(url).matches();
  }
}
