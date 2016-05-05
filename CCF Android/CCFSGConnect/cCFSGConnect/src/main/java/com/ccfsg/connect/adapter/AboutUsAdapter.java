package com.ccfsg.connect.adapter;

import java.util.ArrayList;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.ccfsg.connect.R;
import com.ccfsg.connect.beans.CCFDetail;

public class AboutUsAdapter extends ArrayAdapter<CCFDetail> {

    private static final String TAG = "AboutUsAdapter";

    private ArrayList<CCFDetail> detailList;
    private LayoutInflater layoutInflater;

    public AboutUsAdapter(Activity context, ArrayList<CCFDetail> eventList) {
        super(context, 0, eventList);
        this.detailList = eventList;
        layoutInflater = (LayoutInflater) context.getSystemService(context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null)
        {
        	convertView = layoutInflater.inflate(R.layout.row_about_us, null);
        }
        ViewHolder holder = new ViewHolder(convertView);
        
        CCFDetail event = detailList.get(position);

        holder.title.setText(event.getText());
        holder.subTitle.setText( event.getValue() );
	    return convertView;
    }
    
    protected static class ViewHolder{
        public TextView title;
        public TextView subTitle;

        public ViewHolder(View root){
        	title = (TextView) root.findViewById( R.id.textview_text );
        	subTitle = (TextView) root.findViewById( R.id.textview_value );
        }
    }
}
