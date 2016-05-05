package com.ccfsg.connect.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View.MeasureSpec;
import android.widget.ImageView;

public class AspectRatioImageView extends ImageView {
	private static final String TAG = "AspectRatioImageView";

    public AspectRatioImageView(Context context) {
        super(context);
    }

    public AspectRatioImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public AspectRatioImageView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int width = MeasureSpec.getSize(widthMeasureSpec);
        int height = MeasureSpec.getSize(heightMeasureSpec);
        
        try{
        	if (height == 0){
            	height = width * getDrawable().getIntrinsicHeight() / getDrawable().getIntrinsicWidth();
            }
            else if (width == 0){
            	width =  height * getDrawable().getIntrinsicWidth() / getDrawable().getIntrinsicHeight();
            }
        }
        catch(Exception e){
        }
        
        setMeasuredDimension(width, height);
    }
}