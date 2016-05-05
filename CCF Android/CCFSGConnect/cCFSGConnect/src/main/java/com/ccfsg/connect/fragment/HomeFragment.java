package com.ccfsg.connect.fragment;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.ccfsg.connect.MainActivity;
import com.ccfsg.connect.R;
import com.ccfsg.connect.utils.ConversionUtil;
import com.ccfsg.connect.utils.ScreenUtils;

public class HomeFragment extends Fragment implements OnClickListener {

    public static String TAG = "WebViewFragment";
    private final static String TARGET_EXTERNAL = "targetbrowser=external";
	private ImageView homeImageView;
	private ImageView videosImageView;
	private ImageView dgroupImageView;
	private ImageView forumImageView;
	private ImageView bibleImageView;
	private ImageView eventImageView;
	private ImageView ministryImageView;
	private ImageView resourcesImageView;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setTitle( getString( R.string.home ).toUpperCase() );
    }
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_home, container, false);
        setView( v );
        return v;
    }
    
    @SuppressLint("NewApi")
	private void setView( View v )
	{
		homeImageView = (ImageView) v.findViewById(R.id.imageview_sg);
		videosImageView = (ImageView) v.findViewById(R.id.imageview_videos);
		dgroupImageView = (ImageView) v.findViewById(R.id.imageview_dgroups);
		forumImageView = (ImageView) v.findViewById(R.id.imageview_forums);
		bibleImageView = (ImageView) v.findViewById(R.id.imageview_bible);
		eventImageView = (ImageView) v.findViewById(R.id.imageview_events);
		ministryImageView = (ImageView) v.findViewById(R.id.imageview_ministry);
		resourcesImageView = (ImageView) v.findViewById(R.id.imageview_resources);
		
		if( ScreenUtils.isPhone( getActivity() ) )
		{
			homeImageView.setLayoutParams(new LinearLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()), 
        		getResources().getDimensionPixelOffset( R.dimen.home_height )));

			videosImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()), 
        		getResources().getDimensionPixelOffset( R.dimen.video_height )));

			dgroupImageView.setLayoutParams(new LinearLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()), 
        		getResources().getDimensionPixelOffset( R.dimen.dgroup_height )));

			forumImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()), 
        		getResources().getDimensionPixelOffset( R.dimen.forum_height )));
			
			bibleImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) / 2, 
        		ScreenUtils.getScreenWidth(getActivity()) / 2) );
			
			eventImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) / 2, 
        		ScreenUtils.getScreenWidth(getActivity()) / 2) );
			
			ministryImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) / 2, 
        		ScreenUtils.getScreenWidth(getActivity()) / 2) );
				
			resourcesImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) / 2, 
        		ScreenUtils.getScreenWidth(getActivity()) / 2) );
		}
		else
		{
			homeImageView.setLayoutParams(new LinearLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ), 
        		getResources().getDimensionPixelOffset( R.dimen.home_height )));

			videosImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ), 
        		getResources().getDimensionPixelOffset( R.dimen.video_height )));

			dgroupImageView.setLayoutParams(new LinearLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ), 
        		getResources().getDimensionPixelOffset( R.dimen.dgroup_height )));

			forumImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ), 
        		getResources().getDimensionPixelOffset( R.dimen.forum_height )));
			
			bibleImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4, 
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4) );
				
			eventImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4, 
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4) );
			
			ministryImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4, 
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4) );
				
			resourcesImageView.setLayoutParams(new RelativeLayout.LayoutParams(
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4, 
        		(ScreenUtils.getScreenWidth(getActivity()) - ConversionUtil.toPixel( 300, getActivity() ) )/ 4) );
		}
		videosImageView.setOnClickListener( this );
		dgroupImageView.setOnClickListener( this );
		forumImageView.setOnClickListener( this );
		bibleImageView.setOnClickListener( this );
		eventImageView.setOnClickListener( this );
		ministryImageView.setOnClickListener( this );
		resourcesImageView.setOnClickListener( this );
	}

	@Override
	public void onClick(View v) 
	{
		if( v == videosImageView )
		{
			((MainActivity) getActivity() ).renderVideo();
		}
		else if( v == dgroupImageView )
		{
			((MainActivity) getActivity() ).renderDgroup();
			
		}
		else if( v == forumImageView )
		{
			((MainActivity) getActivity() ).renderForums();
		}
		else if( v == bibleImageView )
		{
			((MainActivity) getActivity() ).renderOneYearBible();
		}
		else if( v == eventImageView )
		{
			((MainActivity) getActivity() ).renderEventList();
		}
		else if( v == ministryImageView )
		{
			((MainActivity) getActivity() ).renderMinistryList();
		}
		else if( v == resourcesImageView )
		{
			((MainActivity) getActivity() ).renderResource();
		}
	}
}
