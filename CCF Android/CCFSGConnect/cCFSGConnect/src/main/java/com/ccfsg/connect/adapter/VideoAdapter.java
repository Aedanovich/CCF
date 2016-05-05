package com.ccfsg.connect.adapter;

import java.util.ArrayList;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.ccfsg.connect.R;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.VimeoDetail;
import com.ccfsg.connect.utils.ConversionUtil;
import com.ccfsg.connect.utils.ScreenUtils;
import com.ccfsg.connect.utils.StringUtils;

public class VideoAdapter extends ArrayAdapter<VimeoDetail> {

    private static final String TAG = "SearchItemAdapter";

    private ArrayList<VimeoDetail> videoList;
    private LayoutInflater layoutInflater;
    private Activity activity;

    public VideoAdapter(Activity context, ArrayList<VimeoDetail> videoList) {
        super(context, 0, videoList);
        this.videoList = videoList;
        layoutInflater = (LayoutInflater) context.getSystemService(context.LAYOUT_INFLATER_SERVICE);
        activity = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null)
        {
        	convertView = layoutInflater.inflate(R.layout.row_video, null);
        }
        ViewHolder holder = new ViewHolder(convertView);
        
        VimeoDetail video = videoList.get(position);

        holder.title.setText(video.getTitle());
        holder.subTitle.setText( StringUtils.replace( video.getDescription(),"<br />", "" ).trim() );
        if( holder.subTitle.getText().length() == 0 )
        {
        	holder.subTitle.setVisibility( View.GONE );
        }
        if( ScreenUtils.isPhone( activity ) )
        {
        	holder.image.setLayoutParams(new RelativeLayout.LayoutParams(ScreenUtils.getScreenWidth( activity ), (int) (ScreenUtils.getScreenWidth( activity ) * 0.575)));
        }
        else
        {
        	holder.image.setLayoutParams(new RelativeLayout.LayoutParams((ScreenUtils.getScreenWidth( activity ) - ConversionUtil.toPixel( 300, activity ))/2, (int) ((ScreenUtils.getScreenWidth( activity ) - ConversionUtil.toPixel( 300, activity )) / 2 * 0.575)));
        }
        VolleyManager.loadImage(getContext(), holder.image, video.getThumbnailLarge(), R.drawable.placeholder );
	    return convertView;
    }
    
    protected static class ViewHolder{
        public TextView title;
        public TextView subTitle;
        public NetworkImageView image;

        public ViewHolder(View root){
        	title = (TextView) root.findViewById( R.id.textview_title );
        	subTitle = (TextView) root.findViewById( R.id.textview_subtitle );
        	image = (NetworkImageView) root.findViewById( R.id.imageview_image );
        }
    }
}
