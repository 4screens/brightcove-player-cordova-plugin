package net.nopattern.cordova.brightcoveplayer;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.util.Patterns;
import android.net.Uri;

public class BrightcovePlayerPlugin extends CordovaPlugin {
  protected static final String LOG_TAG = "[BrightcovePlayerPlugin]";
  private String token = null;

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
    } else if(action.equals("init")) {
      String token = args.getString(0);
      this.initBrightcove(token, callbackContext);
    }
    return false;
  }

  private void playByUrl(String url, CallbackContext callbackContext) {
    if (this.token == null){
      callbackContext.error(LOG_TAG + " Please init the brightcove with token!");
      return;
    }
    if (this.urlIsValid(url)) {
      callbackContext.success(LOG_TAG + " Playing now: " + url);
    } else {
      callbackContext.error(LOG_TAG + " URL is not valid or empty!");
    }
  }

  private void playById(String id, CallbackContext callbackContext) {
    if (this.token == null){
      callbackContext.error(LOG_TAG + " Please init the brightcove with token!");
      return;
    }
    if (id != null && id.length() > 0){

      Context context = this.cordova.getActivity().getApplicationContext();
      Intent intent = new Intent(context, BrightcoveActivity.class);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
      intent.putExtra("video-id", id);
      intent.putExtra("brightcove-token", this.token);
      context.startActivity(intent);

      callbackContext.success(LOG_TAG + " Playing now: " + id + ", Token: " + this.token);
    } else{
      callbackContext.error(LOG_TAG + " Empty video ID!");
    }
  }

  private void initBrightcove(String token, CallbackContext callbackContext) {
    if (token != null && token.length() > 0){
      this.token = token;
      callbackContext.success(LOG_TAG + " Inited");
    } else{
      callbackContext.error(LOG_TAG + " Empty Brightcove token!");
    }
  }

  private boolean urlIsValid(String url) {
    return Patterns.WEB_URL.matcher(url).matches();
  }
}
