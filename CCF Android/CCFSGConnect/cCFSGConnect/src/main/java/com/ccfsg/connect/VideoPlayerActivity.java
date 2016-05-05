package com.ccfsg.connect;

import android.app.Activity;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.MediaController;
import android.widget.ProgressBar;
import android.widget.VideoView;

public class VideoPlayerActivity extends Activity implements OnPreparedListener, OnCompletionListener {
	
	public static final String URL = "url";
	private ProgressBar progressBar;
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		if (Build.VERSION.SDK_INT < 16)
		{
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        }
		else
		{
			View decorView = getWindow().getDecorView();
			int uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;
			decorView.setSystemUiVisibility(uiOptions);
		}
	    setContentView(R.layout.activity_video_player);
	    VideoView videoView =(VideoView)findViewById(R.id.videoView);
	    progressBar = (ProgressBar) findViewById( R.id.progress_bar );
	    MediaController mediaController= new MediaController(this);
	    mediaController.setAnchorView(videoView);        
	    Uri uri = Uri.parse( getIntent().getStringExtra( URL ) );        
	    videoView.setMediaController(mediaController);
	    videoView.setVideoURI(uri);        
	    videoView.requestFocus();

	    videoView.setOnPreparedListener( this );
	    videoView.setOnCompletionListener( this );
	    videoView.start();
    }
	@Override
	public void onPrepared(MediaPlayer player)
	{	
		progressBar.setVisibility( View.GONE );
		
	}
	@Override
	public void onCompletion(MediaPlayer player)
	{
		finish();
	}
	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
	        super.onWindowFocusChanged(hasFocus);
	    if (hasFocus) {
	    	getWindow().getDecorView().setSystemUiVisibility(
	                View.SYSTEM_UI_FLAG_LOW_PROFILE);}
	}

    @Override
    public boolean onOptionsItemSelected(MenuItem item) 
	{
		if (item.getItemId() == android.R.id.home) 
		{
            finish();
        }
        else
        {
            super.onOptionsItemSelected(item);
        }
        return true;
    }
}  