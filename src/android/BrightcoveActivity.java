package net.nopattern.cordova.brightcoveplayer;

import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.MediaController;
import android.widget.ProgressBar;

import com.brightcove.ima.GoogleIMAComponent;
import com.brightcove.ima.GoogleIMAEventType;
import com.brightcove.ima.GoogleIMAVideoAdPlayer;

import com.brightcove.player.event.Event;
import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.event.EventListener;
import com.brightcove.player.event.EventType;
import com.brightcove.player.media.Catalog;
import com.brightcove.player.media.VideoListener;
import com.brightcove.player.media.VideoFields;
import com.brightcove.player.model.CuePoint;
import com.brightcove.player.model.Video;
import com.brightcove.player.model.Source;
import com.brightcove.player.util.StringUtil;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveVideoView;

import com.google.ads.interactivemedia.v3.api.AdDisplayContainer;
import com.google.ads.interactivemedia.v3.api.AdsRequest;
import com.google.ads.interactivemedia.v3.api.CompanionAdSlot;
import com.google.ads.interactivemedia.v3.api.ImaSdkFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BrightcoveActivity extends BrightcovePlayer {

  private EventEmitter eventEmitter;
  private GoogleIMAComponent googleIMAComponent;
  private ProgressBar spinner;

  private static final String LAYOUT = "layout";
  private static final String ID = "id";
  private static final String BRIGHTCOVE_ACTIVITY = "bundled_video_activity_brightcove";
  private static final String BRIGHTCOVE_VIEW = "brightcove_video_view";
  private static final String TAG = "BrightcoveCordovaPluginActivity";
  private static final String PROGRESS_BAR = "progressBar1";
  private static final String AD_FRAME = "ad_frame";

  private String token = null;
  private String videoId = null;
  private String videoUrl = null;
  private String vast = null;

  private String adRulesURL = "http://tvn.adocean.pl/ad.xml?aocodetype=1/predur=46/postdur=46/overdur=65/id=lLs82a1K3Q9SGe_YJEhp0F4LQdvR2IeIUxQUOODMIvb.Z7/tvn_content_category=wideo/tvn_content_category2=castingi/tvn_traffic_tags=zielony/tvn_traffic_category=kobieta,mlodziez/tvn_page=1401747_agustin_zatanczyl_cha_che_z_tomaszem/tvn_device_type=Android";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    setContentView(this.getIdFromResources(BRIGHTCOVE_ACTIVITY, LAYOUT));
    brightcoveVideoView = (BrightcoveVideoView) findViewById(this.getIdFromResources(BRIGHTCOVE_VIEW, ID));

    spinner = (ProgressBar)findViewById(this.getIdFromResources(PROGRESS_BAR, ID));

    super.onCreate(savedInstanceState);
    eventEmitter = brightcoveVideoView.getEventEmitter();

    Log.d(TAG, "Init");

    Intent intent = getIntent();

    token = intent.getStringExtra("brightcove-token");
    videoId = intent.getStringExtra("video-id");
    videoUrl = intent.getStringExtra("video-url");
    vast = intent.getStringExtra("vast-link");

    Log.d(TAG, "Vast link: " + vast);

    setupGoogleIMA();

    Map<String, String> options = new HashMap<String, String>();
    List<String> values = new ArrayList<String>(Arrays.asList(VideoFields.DEFAULT_FIELDS));
    values.remove(VideoFields.HLS_URL);
    options.put("video_fields", StringUtil.join(values, ","));

    if (videoId != null){
      playById(token, videoId);
    } else if (videoUrl != null){
      playByUrl(videoUrl);
    }
    return;

  }

  private int getIdFromResources(String what, String where){
    String package_name = getApplication().getPackageName();
    Resources resources = getApplication().getResources();
    return resources.getIdentifier(what, where, package_name);
  }

  private void playById(String token, String id){
    Log.d(TAG, "Playing video from brightcove ID: " + id);

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

    token = null;
    videoId = null;
    vast = null;

    return;
  }

  private void playByUrl(String url){
    Log.d(TAG, "Playing video from url: " + url);
    this.fullScreen();

    brightcoveVideoView.add(Video.createVideo(url));
    brightcoveVideoView.start();

    token = null;
    videoUrl = null;
    vast = null;

    return;
  }

  private void setupCuePoints(Source source) {
    String cuePointType = "ad";
    Map<String, Object> properties = new HashMap<String, Object>();
    Map<String, Object> details = new HashMap<String, Object>();

    CuePoint cuePoint = new CuePoint(CuePoint.PositionType.BEFORE, cuePointType, properties);
    details.put(Event.CUE_POINT, cuePoint);
    eventEmitter.emit(EventType.SET_CUE_POINT, details);
  }


  private void setupGoogleIMA() {

    final int adFrameId = this.getIdFromResources("ad_frame", ID);
    final String vastLink = vast;
    final ProgressBar spinnerInst = spinner;

    eventEmitter.on(EventType.DID_PLAY, new EventListener(){
      @Override
      public void processEvent(Event event) {
        spinnerInst.setVisibility(View.GONE);
      }
    });

    eventEmitter.on(EventType.DID_SET_SOURCE, new EventListener() {
      @Override
      public void processEvent(Event event) {
        setupCuePoints((Source) event.properties.get(Event.SOURCE));
      }
    });

    final ImaSdkFactory sdkFactory = ImaSdkFactory.getInstance();

    eventEmitter.on(GoogleIMAEventType.DID_START_AD, new EventListener() {
      @Override
      public void processEvent(Event event) {
        Log.v(TAG, event.getType());
        spinnerInst.setVisibility(View.GONE);
      }
    });

    eventEmitter.on(GoogleIMAEventType.DID_FAIL_TO_PLAY_AD, new EventListener() {
      @Override
      public void processEvent(Event event) {
        Log.v(TAG, event.getType());
      }
    });

    eventEmitter.on(GoogleIMAEventType.DID_COMPLETE_AD, new EventListener() {
      @Override
      public void processEvent(Event event) {
        Log.v(TAG, event.getType());
        spinnerInst.setVisibility(View.VISIBLE);
      }
    });

    eventEmitter.on(GoogleIMAEventType.ADS_REQUEST_FOR_VIDEO, new EventListener() {
      @Override
      public void processEvent(Event event) {
        AdDisplayContainer container = sdkFactory.createAdDisplayContainer();
        container.setPlayer(googleIMAComponent.getVideoAdPlayer());
        container.setAdContainer(brightcoveVideoView);

        ArrayList<CompanionAdSlot> companionAdSlots = new ArrayList<CompanionAdSlot>();
        CompanionAdSlot companionAdSlot = sdkFactory.createCompanionAdSlot();
        ViewGroup adFrame = (ViewGroup) findViewById(adFrameId);
        companionAdSlot.setContainer(adFrame);
        companionAdSlot.setSize(adFrame.getWidth(), adFrame.getHeight());
        companionAdSlots.add(companionAdSlot);
        container.setCompanionSlots(companionAdSlots);

        AdsRequest adsRequest = sdkFactory.createAdsRequest();
        adsRequest.setAdTagUrl(vastLink);
        adsRequest.setAdDisplayContainer(container);

        ArrayList<AdsRequest> adsRequests = new ArrayList<AdsRequest>(1);
        adsRequests.add(adsRequest);

        event.properties.put(GoogleIMAComponent.ADS_REQUESTS, adsRequests);
        eventEmitter.respond(event);
      }
    });

    googleIMAComponent = new GoogleIMAComponent(brightcoveVideoView, eventEmitter);
  }
}