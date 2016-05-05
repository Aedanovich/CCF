package com.ccfsg.connect.beans;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;

/**
 * Created by viki on 6/6/13.
 */
public class FragmentItem{
    private Class mClass;
    private String tag;
    private Bundle extras;
    private Fragment fragment;

    public FragmentItem(Class mClass, String tag, Bundle extras){
        this.mClass = mClass;
        this.tag = tag;
        this.extras = extras;
    }

    public void addFragmentPage(String fragmentPage){
        this.tag = fragmentPage + "-" + tag;
    }

    public Fragment getFragment(){
        return fragment;
    }

    public void createFragment(Activity activity){
        fragment = Fragment.instantiate(activity, mClass.getName(), extras);
    }

    public String getTag(){
        return tag;
    }
}
