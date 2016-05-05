package com.ccfsg.connect.utils;

import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import com.ccfsg.connect.fragment.ProgressDialogFragment;

public class DialogUtils {
	private static final String TAG = "ProgressDialogUtils";
	
	public static void showProgressDialog(FragmentActivity activity, String tagName){
		try{
			FragmentTransaction ft = activity.getSupportFragmentManager().beginTransaction();
			ProgressDialogFragment dialog = (ProgressDialogFragment)activity.getSupportFragmentManager().findFragmentByTag(tagName);
			if (dialog == null) {
				dialog = new ProgressDialogFragment();
				dialog.show(ft, tagName);
			}
		}
		catch(Exception e){
		}
	}
	
	public static boolean dismissDialogFragment(FragmentActivity activity, String tagName){
	    if (activity != null) {
	        FragmentManager fm = activity.getSupportFragmentManager();
	        FragmentTransaction ft = fm.beginTransaction();
	        if (fm.findFragmentByTag(tagName) != null){
	            ProgressDialogFragment f = (ProgressDialogFragment)fm.findFragmentByTag(tagName);
	            f.dismissAllowingStateLoss();
	            ft.remove(f).commitAllowingStateLoss();
	            return f.isCancelled();
	        }
	    }
	    return false;
	}
}
