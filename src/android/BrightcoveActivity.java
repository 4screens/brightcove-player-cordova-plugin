package net.nopattern.cordova.brightcoveplayer;

import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.MediaController;

import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveVideoView;

public class BrightcoveActivity extends BrightcovePlayer {

  private static final String LAYOUT = "layout";
  private static final String ID = "id";
  private static final String BRIGHTCOVE_ACTIVITY = "bundled_video_activity_brightcove";
  private static final String BRIGHTCOVE_VIEW = "brightcove_video_view";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    setContentView(this.getIdFromResources(BRIGHTCOVE_ACTIVITY, LAYOUT));
    brightcoveVideoView = (BrightcoveVideoView) findViewById(this.getIdFromResources(BRIGHTCOVE_VIEW, ID));
    super.onCreate(savedInstanceState);

    Log.d("BrightcovePlugin", "Init");

    String PACKAGE_NAME = getApplicationContext().getPackageName();
    Uri video = Uri.parse("android.resource://" + PACKAGE_NAME + "/" + this.getIdFromResources("shark", "raw"));
    brightcoveVideoView.add(Video.createVideo(video.toString()));
    this.fullScreen();
    brightcoveVideoView.start();
  }

  private int getIdFromResources(String what, String where){
    String package_name = getApplication().getPackageName();
    Resources resources = getApplication().getResources();
    return resources.getIdentifier(what, where, package_name);
  }
}