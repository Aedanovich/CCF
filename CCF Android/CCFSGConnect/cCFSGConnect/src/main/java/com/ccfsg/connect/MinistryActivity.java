package com.ccfsg.connect;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.Ministry;
import com.ccfsg.connect.utils.ConversionUtil;
import com.ccfsg.connect.utils.ScreenUtils;

public class MinistryActivity extends ActionBarActivity implements OnClickListener {

	public static final String MINISTRY = "ministry";
    public static String TAG = "MinistryActivity";
	private NetworkImageView headerImageView;
	private TextView titleTextView;
	private TextView detailsTextView;
	private Button joinButton;
	private Ministry ministry;
    
    public void initActionBar()
    {
    	ActionBar actionBar = getSupportActionBar();
    	actionBar.setTitle( ministry.getName().toUpperCase() );
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
		setContentView(R.layout.activity_ministry);
        ministry = getIntent().getParcelableExtra( MINISTRY );
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
		
		headerImageView.setLayoutParams(new LinearLayout.LayoutParams(
    		ScreenUtils.getScreenWidth( this ), 
    		getResources().getDimensionPixelOffset( R.dimen.home_height )));
		
		VolleyManager.loadImage(this, headerImageView, ministry.getImage(), R.drawable.placeholder );
	    
		titleTextView.setText( ministry.getName() );
		detailsTextView.setText( ministry.getDetails() );
		
		joinButton.setOnClickListener( this );
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
    
	@Override
	public void onClick(View v) 
	{
		if( v == joinButton )
		{
			Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
			emailIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			emailIntent.setType("vnd.android.cursor.item/email");
			emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[] { ministry.getEmail() });
			emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "I want to join the " + ministry.getName() + " Ministry" );
			emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, "Name:\nContact Info:\nDGroup:");
			startActivity(Intent.createChooser(emailIntent, "Send mail using..."));
		}
	}
}