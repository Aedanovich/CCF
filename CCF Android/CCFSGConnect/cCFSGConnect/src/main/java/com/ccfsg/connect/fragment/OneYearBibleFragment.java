package com.ccfsg.connect.fragment;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.CalendarView;
import android.widget.CalendarView.OnDateChangeListener;
import android.widget.DatePicker;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.ccfsg.connect.MainActivity;
import com.ccfsg.connect.R;
import com.ccfsg.connect.utils.DateUtils;
import com.ccfsg.connect.utils.ScreenUtils;
import com.ccfsg.connect.utils.StringUtils;

public class OneYearBibleFragment extends Fragment implements OnClickListener, OnDateChangeListener {

    public static String TAG = "WebViewFragment";
    private final static String TARGET_EXTERNAL = "targetbrowser=external";
	private WebView webView;
	private Button dateButton;
	private DatePicker datePicker;
	private View divider;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setTitle( getString( R.string.one_year_bible ).toUpperCase() );
    }
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_one_year_bible, container, false);
        setView( v );
        return v;
    }
    
    @SuppressLint("NewApi")
	private void setView( View v )
	{
		webView = (WebView) v.findViewById(R.id.web);
		dateButton = (Button) v.findViewById( R.id.button_date );
		datePicker = (DatePicker) v.findViewById( R.id.datepicker );
		divider = v.findViewById( R.id.divider );
		datePicker.getCalendarView().setOnDateChangeListener( this );
		datePicker.setMinDate( DateUtils.getFirstDateOfCurrentMonth() );
		datePicker.setMaxDate( DateUtils.getLastDateOfCurrentMonth() );
		String url = "http://www.esvapi.org/v2/rest/readingPlanQuery?date=[date]&key=e43d263178c650d2";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String currentDate = sdf.format(new Date());
		url = StringUtils.replace( url, "[date]", currentDate);
		webView.getSettings().setJavaScriptEnabled(true);
		if( ScreenUtils.isTablet( getActivity() ) )
		{
			float fontSize = getResources().getDimension(R.dimen.webview_text_size);
			webView.getSettings().setDefaultFontSize((int)fontSize);
		}
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
    	            	datePicker.setVisibility( View.GONE );
    	            }
            	}
            	catch( Exception e ) {}
	         }
		});
		webView.getSettings().setAppCacheMaxSize(1024*1024*8); 
		
		webView.loadUrl(url);
		webView.setVisibility( View.VISIBLE );
		dateButton.setOnClickListener( this );

		Calendar c = Calendar.getInstance();
		SimpleDateFormat sdf2 = new SimpleDateFormat("MMMM dd, yyyy");
		String currentDate2 = sdf2.format(c.getTime());
		dateButton.setText( currentDate2 );
	}
    
    public boolean canBack()
    {
    	return datePicker.getVisibility() == View.VISIBLE || webView.canGoBack();
    }
    
    public void back()
    {
    	if( datePicker.getVisibility() == View.VISIBLE )
    	{
    		datePicker.setVisibility( View.GONE );
    	}
    	else
    	{
    		webView.goBack();
    	}
    }

	@Override
	public void onClick(View v)
	{
		if( v == dateButton )
		{
			datePicker.setVisibility( datePicker.getVisibility() == View.VISIBLE ? View.GONE : View.VISIBLE );
	
			RelativeLayout.LayoutParams p = (RelativeLayout.LayoutParams) divider.getLayoutParams();
			p.addRule( RelativeLayout.ABOVE, datePicker.getId() );
			divider.setLayoutParams( p );
		}
	}

	@Override
	public void onSelectedDayChange(CalendarView v, int year, int monthOfYear, int dayOfMonth)
	{
		String url = "http://www.esvapi.org/v2/rest/readingPlanQuery?date=[date]&key=e43d263178c650d2";
		
		String domText = "";
		if( dayOfMonth < 10 )
		{
			domText = "0" + dayOfMonth;
		}
		else
		{
			domText = "" + dayOfMonth;
		}
		
		String monthText = "";
		if( monthOfYear + 1 < 10 )
		{
			monthText = "0" + ( monthOfYear + 1 );
		}
		else
		{
			monthText = "" + ( monthOfYear + 1 );
		}
		
		url = StringUtils.replace( url, "[date]", year + "-" + monthText + "-" + domText );
		webView.loadUrl(url);
		Calendar c = Calendar.getInstance();
		c.set( year, monthOfYear, dayOfMonth);
		SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
		String currentDate = sdf.format(c.getTime());
		dateButton.setText( currentDate );
	}
}