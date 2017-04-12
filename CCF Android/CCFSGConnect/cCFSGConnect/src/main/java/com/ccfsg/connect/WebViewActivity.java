package com.ccfsg.connect;

import android.annotation.SuppressLint;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import com.ccfsg.connect.utils.ScreenUtils;

public class WebViewActivity  extends ActionBarActivity {

	public static final String URL = "url";
	public static final String TITLE = "title";
	public static final String EMBEDCODE = "";
    public static String TAG = "WebViewActivity";
	private WebView webView;
	private String url;
	private String title;
	private String embedCode;

    private void initActionBar()
    {
    	ActionBar actionBar = getSupportActionBar();
    	actionBar.setDisplayShowHomeEnabled(true);
    	actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setDisplayUseLogoEnabled(true);
        actionBar.setTitle( title );
        actionBar.setLogo(getResources().getDrawable(R.drawable.ic_launcher));
        actionBar.setIcon(getResources().getDrawable(R.drawable.ic_launcher));
        actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    }
    @Override
    public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ScreenUtils.setCorrectOrientation( this );
		supportRequestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_webview);
        url = getIntent().getStringExtra( URL );
        title = getIntent().getStringExtra( TITLE );
		embedCode = getIntent().getStringExtra ( EMBEDCODE );
        setView();
        initActionBar();
    }
    
    @SuppressLint("NewApi")
	private void setView()
	{
    	webView = (WebView) findViewById(R.id.web);
		webView.setWebViewClient(new WebViewClient()
		{
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String urlNewString)
			{
				return false;
			}

			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon)
			{
			}

			@Override
			public void onPageFinished(WebView view, String url)
			{
			}
		});

		webView.setWebChromeClient(new WebChromeClient() {
            public void onProgressChanged(WebView view, int progress) 
            {
	            if(progress < 100 ){
	            	showProgressBar();
	            }
	            if(progress == 100) 
	            {
	            	hideProgressBar();
	            }
	         }
		});
		webView.getSettings().setAllowFileAccess(true);
		webView.getSettings().setBuiltInZoomControls(true);
		webView.getSettings().setSupportZoom(true);
		webView.getSettings().setUseWideViewPort(true);
		webView.getSettings().setLoadWithOverviewMode(true);
		webView.getSettings().setAppCacheEnabled(true);
		webView.getSettings().setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
		webView.getSettings().setJavaScriptEnabled(true);


		if (embedCode.trim().isEmpty())
			webView.loadUrl(url);
		else {
			webView.loadData(embedCode, "text/html", "utf-8");
			this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
		}
//			webView.loadDataWithBaseURL("file:///android_asset/." , embedCode, "text/html", "UTF-8", null);
		webView.setVisibility( View.VISIBLE );
	}

    @Override
    public void onBackPressed(){
        if( canBack() )
        {
        	back();
        }
        else
        {
        	super.onBackPressed();
        }
    }
    
    public boolean canBack()
    {
    	return webView.canGoBack();
    }
    
    public void back()
    {
    	webView.goBack();
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
	
	public void showProgressBar()
	{
		setProgressBarIndeterminateVisibility(true);
	}
	
	public void hideProgressBar()
	{
		setProgressBarIndeterminateVisibility(false);
	}
}