package com.ccfsg.connect.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Surface;

public class ScreenUtils  {

	private static final String TAG = "ScreenUtils";
	private static Screen instance = null;
	private static double screenSize = 0;
	private static final double PHONE_THRESHOLD = 6.5;
    private static int TABLET_THRESHOLD = 600;

	private static Screen getInstance(Activity activity){
		if (instance == null){
			instance = new ScreenUtils().new Screen(activity);
		}
		return instance;
	}

	public static int getScreenWidth(Activity activity){
		return getInstance(activity).getWidth();
	}

	public static int getScreenHeight(Activity activity){
		return getInstance(activity).getHeight();
	}

	public static float getDensity(Activity activity){
		return getInstance(activity).getDensity();
	}
	
	public static double getScreenSize(Activity activity){
		if (screenSize == 0){
			DisplayMetrics dm = new DisplayMetrics();
			activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
			double x = Math.pow(dm.widthPixels/dm.xdpi,2);
			double y = Math.pow(dm.heightPixels/dm.ydpi,2);
			screenSize = Math.sqrt(x+y);
		}
		return screenSize;
	}
	
	public static int getScreenOrientation( Activity activity ) {
	    int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();
	    DisplayMetrics dm = new DisplayMetrics();
	    activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
	    int width = dm.widthPixels;
	    int height = dm.heightPixels;
	    int orientation;
	    // if the device's natural orientation is portrait:
	    if ((rotation == Surface.ROTATION_0
	            || rotation == Surface.ROTATION_180) && height > width ||
	        (rotation == Surface.ROTATION_90
	            || rotation == Surface.ROTATION_270) && width > height) {
	        switch(rotation) {
	            case Surface.ROTATION_0:
	                orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
	                break;
	            case Surface.ROTATION_90:
	                orientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;
	                break;
	            case Surface.ROTATION_180:
	                orientation =
	                    ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT;
	                break;
	            case Surface.ROTATION_270:
	                orientation =
	                    ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
	                break;
	            default:
	                Log.e(TAG, "Unknown screen orientation. Defaulting to " +
	                        "portrait.");
	                orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
	                break;              
	        }
	    }
	    // if the device's natural orientation is landscape or if the device
	    // is square:
	    else {
	        switch(rotation) {
	            case Surface.ROTATION_0:
	                orientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;
	                break;
	            case Surface.ROTATION_90:
	                orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
	                break;
	            case Surface.ROTATION_180:
	                orientation =
	                    ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
	                break;
	            case Surface.ROTATION_270:
	                orientation =
	                    ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT;
	                break;
	            default:
	                Log.e(TAG, "Unknown screen orientation. Defaulting to " +
	                        "landscape.");
	                orientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;
	                break;              
	        }
	    }

	    return orientation;
	}

	class Screen{
		private int width;
		private int height;
		private float density;
		private float widthDpi;
		private float heightDpi;

		public Screen(Activity activity){

			DisplayMetrics metrics = activity.getResources().getDisplayMetrics();
			if( activity.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE )
			{
				if( isTablet( activity ) )
				{
					width = metrics.widthPixels;
					height = metrics.heightPixels;
					widthDpi = metrics.xdpi;
					heightDpi = metrics.ydpi;
				}
				else
				{
					height = metrics.widthPixels;
					width = metrics.heightPixels;
					heightDpi = metrics.xdpi;
					widthDpi = metrics.ydpi;
				}
			}
			else
			{
				if( isTablet( activity ) )
				{
					height = metrics.widthPixels;
					width = metrics.heightPixels;
					heightDpi = metrics.xdpi;
					widthDpi = metrics.ydpi;
				}
				else
				{
					width = metrics.widthPixels;
					height = metrics.heightPixels;
					widthDpi = metrics.xdpi;
					heightDpi = metrics.ydpi;
				}
			}
		}

		public int getWidth() {
			return width;
		}
		public void setWidth(int width) {
			this.width = width;
		}
		public int getHeight() {
			return height;
		}
		public void setHeight(int height) {
			this.height = height;
		}
		public float getDensity() {
			return density;
		}
		public void setDensity(float density) {
			this.density = density;
		}
		public float getWidthDpi() {
			return widthDpi;
		}
		public void setWidthDpi(float widthDpi) {
			this.widthDpi = widthDpi;
		}
		public float getHeightDpi() {
			return heightDpi;
		}
		public void setHeightDpi(float heightDpi) {
			this.heightDpi = heightDpi;
		}
	}
	
	@SuppressLint("NewApi")
	public static boolean isPhone(Activity activity)
	{
		if( android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2 )
		{
			Configuration config = activity.getResources().getConfiguration();
			if (config.smallestScreenWidthDp >= TABLET_THRESHOLD) {
		            return false;
		    } else {
		            return true;
		    }
		}
		else{
			return getScreenSize(activity) < PHONE_THRESHOLD;
		}
	}
	
	public static boolean isTablet(Activity activity) {
        return !isPhone(activity);
	}
	
	public static void setCorrectOrientation(Activity activity)
    {
        activity.setRequestedOrientation( 
        	ScreenUtils.isPhone(activity) ?
    		ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT : 
    		ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE );
    }
}

