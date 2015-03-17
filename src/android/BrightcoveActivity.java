package net.nopattern.cordova.brightcoveplayer;

import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.MediaController;

import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.media.Catalog;
import com.brightcove.player.media.VideoListener;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveVideoView;

public class BrightcoveActivity extends BrightcovePlayer {

  private static final String LAYOUT = "layout";
  private static final String ID = "id";
  private static final String BRIGHTCOVE_ACTIVITY = "bundled_video_activity_brightcove";
  private static final String BRIGHTCOVE_VIEW = "brightcove_video_view";
  private static final String TAG = "BrightcoveCordovaPlugin";

  private String token = null;
  private String videoId = null;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    setContentView(this.getIdFromResources(BRIGHTCOVE_ACTIVITY, LAYOUT));
    brightcoveVideoView = (BrightcoveVideoView) findViewById(this.getIdFromResources(BRIGHTCOVE_VIEW, ID));
    super.onCreate(savedInstanceState);

    Log.d(TAG, "Init");

    Intent intent = getIntent();

    token = intent.getStringExtra("brightcove-token");
    videoId = intent.getStringExtra("video-id");

    Log.d(TAG, "Token: " + token);
    Log.d(TAG, "VideoId: " + videoId);

    this.fullScreen();

    Catalog catalog = new Catalog(token);
    catalog.findVideoByReferenceID(videoId, new VideoListener() {
      public void onVideo(Video video) {
        brightcoveVideoView.add(video);
        brightcoveVideoView.start();
      }
      public void onError(String error) {
        Log.e(TAG, error);
      }
    });
  }

  private int getIdFromResources(String what, String where){
    String package_name = getApplication().getPackageName();
    Resources resources = getApplication().getResources();
    return resources.getIdentifier(what, where, package_name);
  }
}