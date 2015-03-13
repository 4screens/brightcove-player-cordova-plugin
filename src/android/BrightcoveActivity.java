package org.nopattern.cordova.brightcoveplayer;

import android.net.Uri;
import android.os.Bundle;
import android.widget.MediaController;

import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveVideoView;

public class BrightcoveActivity extends BrightcovePlayer {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(this.getFromActivity("bundled_video_activity_brightcove", "layout"));
    brightcoveVideoView = (BrightcoveVideoView) findViewById(this.getFromActivity("brightcove_video_view","id"));
  }

  private int getFromActivity(String what, String where){
    return getApplication().getResources().getIdentifier(what, where, getApplication().getPackageName());
  }
}