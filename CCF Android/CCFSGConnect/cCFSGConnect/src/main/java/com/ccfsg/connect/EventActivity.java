package com.ccfsg.connect;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.Event;
import com.ccfsg.connect.utils.ConversionUtil;
import com.ccfsg.connect.utils.ScreenUtils;

public class EventActivity extends ActionBarActivity implements OnClickListener {

	public static final String EVENT = "event";
    public static String TAG = "EventFragment";
	private NetworkImageView headerImageView;
	private TextView titleTextView;
	private TextView detailsTextView;
	private TextView venueTextView;
	private TextView dateTextView;
	private TextView timeTextView;
	private TextView memberPriceTextView;
	private TextView guestPriceTextView;
	private Button joinButton;
	private Event event;
    
    public void initActionBar()
    {
    	ActionBar actionBar = getSupportActionBar();
    	actionBar.setTitle( getString( R.string.events ).toUpperCase() );
    	actionBar.setDisplayShowHomeEnabled(true);
    	actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setDisplayUseLogoEnabled(true);
        actionBar.setLogo(getResources().getDrawable(R.drawable.ic_launcher));
        actionBar.setIcon(getResources().getDrawable(R.drawable.ic_launcher));
        actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    }
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ScreenUtils.setCorrectOrientation( this );
		setContentView(R.layout.activity_event);
        event = getIntent().getParcelableExtra( EVENT );
        setView();
        initActionBar();
    }
    
    @SuppressLint("NewApi")
	private void setView()
	{
		headerImageView = (NetworkImageView) findViewById(R.id.imageview_header);
		joinButton = (Button) findViewById(R.id.button_join);
		titleTextView = (TextView) findViewById(R.id.textview_name);
		detailsTextView = (TextView) findViewById(R.id.textview_details);
		venueTextView = (TextView) findViewById(R.id.textview_venue);
		dateTextView = (TextView) findViewById(R.id.textview_date);
		timeTextView = (TextView) findViewById(R.id.textview_time);
		memberPriceTextView = (TextView) findViewById(R.id.textview_member_price);
		guestPriceTextView = (TextView) findViewById(R.id.textview_guest_price);
		
		headerImageView.setLayoutParams(new LinearLayout.LayoutParams(
    		ScreenUtils.getScreenWidth( this ), 
    		getResources().getDimensionPixelOffset( R.dimen.home_height )));
		
		VolleyManager.loadImage(this, headerImageView, event.getImage(), R.drawable.placeholder );
	    
		titleTextView.setText( event.getName() );
		detailsTextView.setText( event.getDetails() );
		venueTextView.setText( event.getVenue() );
		dateTextView.setText( event.getDate() );
		timeTextView.setText( event.getStartTime() + " to " + event.getEndTime() );
		memberPriceTextView.setText( event.getMemberPrice() );
		guestPriceTextView.setText( event.getGuestPrice() );
		
		if( event.getForm().length() > 0 )
		{
			joinButton.setVisibility( View.VISIBLE );
			joinButton.setOnClickListener( this );
		}
	}

	@Override
	public void onClick(View v) 
	{
		if( v == joinButton )
		{
        	Intent myIntent = new Intent( this, WebViewActivity.class);
            myIntent.putExtra( WebViewActivity.URL, event.getForm() );
            myIntent.putExtra( WebViewActivity.TITLE, event.getName() );
			startActivity(myIntent);;
		}
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