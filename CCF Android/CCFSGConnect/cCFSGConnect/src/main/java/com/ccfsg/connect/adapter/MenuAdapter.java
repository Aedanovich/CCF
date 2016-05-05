package com.ccfsg.connect.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.LightingColorFilter;
import android.graphics.PorterDuff;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.ccfsg.connect.R;
import com.ccfsg.connect.beans.Menu;
import com.ccfsg.connect.utils.ScreenUtils;

public class MenuAdapter extends ArrayAdapter<Menu> {

    private static final String TAG = "VolunteerAdapter";

    private int selectedItem;
    private LayoutInflater layoutInflater;
    private FragmentActivity activity;
    public MenuAdapter(FragmentActivity context, ArrayList<Menu> menu ) 
    {
        super(context, 0, menu );
        layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        activity = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) 
    {
        if (convertView == null)
        {
            convertView = layoutInflater.inflate(R.layout.row_menu, null);
        }
        ViewHolder holder = new ViewHolder(convertView);
        
        final Menu menu = getItem(position);
       
        if (position == selectedItem)
        {
            ColorFilter filter = new LightingColorFilter(Color.BLACK, Color.WHITE);
            activity.getResources().getDrawable( menu.getImage() ).setColorFilter(filter);
            convertView.setBackgroundColor(activity.getResources().getColor(R.color.ccf_blue));
            holder.textView.setTextColor(activity.getResources().getColor(R.color.white));
        }
        else
        {
            ColorFilter filter = new LightingColorFilter(Color.WHITE, Color.BLACK);
            activity.getResources().getDrawable( menu.getImage() ).setColorFilter(filter);
            convertView.setBackgroundColor( activity.getResources().getColor( ScreenUtils.isPhone( activity ) ? R.color.white : R.color.tablet_gray ) );
            holder.textView.setTextColor(activity.getResources().getColor( ScreenUtils.isPhone( activity ) ? R.color.dark_grey_sliding_menu : R.color.white ));
        }

        holder.textView.setText( menu.getText() );
        holder.textView.setCompoundDrawablesWithIntrinsicBounds( activity.getResources().getDrawable( menu.getImage() ), null, null, null );
        return convertView;
    }

    protected static class ViewHolder
    {
    	public TextView textView;
        public ViewHolder(View root)
        {
        	textView = (TextView) root.findViewById( R.id.textview_name );
        }
    }
    
    public void setSelectedItem(int selectedItem){
        this.selectedItem = selectedItem;
    }
    
    public int getSelectedItem()
    {
    	return selectedItem;
    }
}