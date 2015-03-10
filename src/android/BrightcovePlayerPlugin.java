package org.nopattern.cordova.brightcoveplayer;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Patterns;

public class BrightcovePlayerPlugin extends CordovaPlugin {

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("play")) {
      String url = args.getString(0);
      this.play(url, callbackContext);
      return true;
    }
    return false;
  }

  private void play(String url, CallbackContext callbackContext) {
    if (this.urlIsValid(url)) {
      callbackContext.success("Playing now: " + url);
    } else {
      callbackContext.error("URL is not valid or empty!");
    }
  }

  private boolean urlIsValid(String url) {
    return Patterns.WEB_URL.matcher(url).matches();
  }
}
