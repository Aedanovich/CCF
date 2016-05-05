package com.ccfsg.connect.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.ccfsg.connect.MainActivity;
import com.ccfsg.connect.R;

public class WorshipServiceRoomsFragment extends Fragment {

    public static String TAG = "WebViewFragment";
    private final static String TARGET_EXTERNAL = "targetbrowser=external";
	private WebView webView;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setTitle( getString( R.string.worship_service_rooms ).toUpperCase() );
    }
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_webview, container, false);
        setView( v );
        return v;
    }
    
    @SuppressLint("NewApi")
	private void setView( View v )
	{
		webView = (WebView) v.findViewById(R.id.web);
		
		String url = "http://www.ccfsingapore.org/worship-service-rooms";
		webView.getSettings().setJavaScriptEnabled(true);
		webView.setVisibility(View.INVISIBLE);
		webView.setWebViewClient(new WebViewClient()
		{
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String urlNewString)
			{
				if (urlNewString.toLowerCase().indexOf(TARGET_EXTERNAL) > 0)
				{
					Uri uri = Uri.parse(urlNewString);
					Intent intent = new Intent(Intent.ACTION_VIEW, uri);
					startActivity(intent);
				}
				else
				{
					webView.loadUrl(urlNewString);
				}

				return true;
			}

			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon)
			{
			}

			@Override
			public void onPageFinished(WebView view, String url)
			{
				view.loadUrl("javascript:(function(){" +
						"var divs = document.getElementsByTagName('div');" +
						"for(var i = 0; i < divs.length; i++){" +
						"if(!(divs[i].id == 'content' || divs[i].id == 'wrapper' || divs[i].id == 'wrapper2' | divs[i].id == 'wrapper3'))\n" +
						"divs[i].style.display = 'none';" +
						"};" +
						"document.getElementById('wrapper').setAttribute('id', 'mainxx');"+
						"})()");
				view.setVisibility(View.VISIBLE);
			}
		});

		webView.setWebChromeClient(new WebChromeClient() {
            public void onProgressChanged(WebView view, int progress) 
            {
            	try
            	{
		            if(progress < 100 ){
		            	((MainActivity) getActivity()).showProgressBar();
		            }
		            if(progress == 100) 
		            {
		            	((MainActivity) getActivity()).hideProgressBar();
		            }
            	}
            	catch( Exception e ) {}
	         }
		});
		int currentapiVersion = android.os.Build.VERSION.SDK_INT;
		if (currentapiVersion >= android.os.Build.VERSION_CODES.ECLAIR_MR1)
		{
			webView.getSettings().setLoadWithOverviewMode(true);
		}
		webView.getSettings().setBuiltInZoomControls(false);
		webView.getSettings().setUseWideViewPort(true);
		webView.getSettings().setAppCacheMaxSize(1024*1024*8); 
		//webView.getSettings().setAppCachePath("/data/data/com.your.package.appname/cache"‌​); 
		webView.getSettings().setAppCacheEnabled(true); 
		webView.getSettings().setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
		
		webView.loadUrl(url);
		//webView.setVisibility( View.VISIBLE );
		
	}
    
    public boolean canBack()
    {
    	return webView.canGoBack();
    }
    
    public void back()
    {
    	webView.goBack();
    }
}
