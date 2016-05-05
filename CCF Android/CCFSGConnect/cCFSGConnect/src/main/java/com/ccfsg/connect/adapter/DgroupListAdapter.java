package com.ccfsg.connect.adapter;

import java.util.ArrayList;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.ccfsg.connect.R;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.DGroup;
import com.ccfsg.connect.utils.ScreenUtils;

public class DgroupListAdapter extends ArrayAdapter<DGroup> {

    private static final String TAG = "DgroupListAdapter";

    private ArrayList<DGroup> dgroupList;
    private LayoutInflater layoutInflater;
    private Activity activity;

    public DgroupListAdapter(Activity context, ArrayList<DGroup> dgroupList) {
        super(context, 0, dgroupList);
        this.dgroupList = dgroupList;
        layoutInflater = (LayoutInflater) context.getSystemService(context.LAYOUT_INFLATER_SERVICE);
        activity = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null)
        {
        	convertView = layoutInflater.inflate(R.layout.row_dgroup, null);
        }
        ViewHolder holder = new ViewHolder(convertView);
        
        DGroup dgroup = dgroupList.get(position);

        holder.title.setText(dgroup.getLocation());
        holder.contact.setText( dgroup.getContact() );
        holder.day.setText( dgroup.getDay() );
        holder.time.setText( dgroup.getTime() );
        holder.group.setText( dgroup.getGroup() );
        
        if( ScreenUtils.isPhone( activity ) )
        {
        	holder.image.setLayoutParams(new RelativeLayout.LayoutParams(ScreenUtils.getScreenWidth( activity ) / 4, (int) (ScreenUtils.getScreenWidth( activity ) / 4 * 0.575)));
           	holder.backupImage.setLayoutParams(new RelativeLayout.LayoutParams(ScreenUtils.getScreenWidth( activity ), (int) (ScreenUtils.getScreenWidth( activity ) * 0.575)));
        }
        else
        {
        	holder.image.setLayoutParams(new RelativeLayout.LayoutParams(ScreenUtils.getScreenWidth( activity ) / 4, (int) (ScreenUtils.getScreenWidth( activity ) / 4 * 0.575)));
           	holder.backupImage.setLayoutParams(new RelativeLayout.LayoutParams(ScreenUtils.getScreenWidth( activity ) / 4, (int) (ScreenUtils.getScreenWidth( activity ) / 4 * 0.575)));
        }
//        if( dgroup.getImage().length() > 0 )
//        {
//        	holder.image.setVisibility( View.VISIBLE );
//        	holder.backupImage.setVisibility( View.INVISIBLE );
//        	VolleyManager.loadImage(getContext(), holder.image, dgroup.getImage(), R.drawable.singapore );
//        }
//        else
        {
        	holder.image.setVisibility( View.INVISIBLE );
        	holder.backupImage.setVisibility( View.VISIBLE );
        	holder.backupImage.setImageResource( getDgroupImage( dgroup ) );
        }
        
        return convertView;
    }
    
    private int getDgroupImage(DGroup dgroup)
    {
    	if( dgroup.getLocation().contains( "Bedok" ) ) return R.drawable.bedok;
    	if( dgroup.getLocation().contains( "Buangkok" ) ) return R.drawable.buangkok;
    	if( dgroup.getLocation().contains( "Clementi" ) ) return R.drawable.clementi;
    	if( dgroup.getLocation().contains( "Dhoby" ) ) return R.drawable.dhoby_ghaut;
    	if( dgroup.getLocation().contains( "Funan" ) ) return R.drawable.funan;
    	if( dgroup.getLocation().contains( "JEM" ) ) return R.drawable.jem;
    	if( dgroup.getLocation().contains( "Lakeside" ) ) return R.drawable.lakeside;
    	if( dgroup.getLocation().contains( "Orchard" ) ) return R.drawable.orchard;
    	if( dgroup.getLocation().contains( "Pasir Ris" ) ) return R.drawable.pasir_ris;
    	if( dgroup.getLocation().contains( "Pioneer" ) ) return R.drawable.pioneer;
    	if( dgroup.getLocation().contains( "CBD" ) ) return R.drawable.raffles;
    	if( dgroup.getLocation().contains( "Rendezvous" ) ) return R.drawable.rendevous;
    	if( dgroup.getLocation().contains( "Sembawang" ) ) return R.drawable.sembawang;
    	if( dgroup.getLocation().contains( "Sengkang" ) ) return R.drawable.sengkang;
    	if( dgroup.getLocation().contains( "Serangoon" ) ) return R.drawable.serangoon;
    	if( dgroup.getLocation().contains( "SMU" ) ) return R.drawable.smu;
    	if( dgroup.getLocation().contains( "Strand" ) ) return R.drawable.strands;
    	if( dgroup.getLocation().contains( "Tampines" ) ) return R.drawable.tampines;
    	if( dgroup.getLocation().contains( "Toa Payoh" ) ) return R.drawable.toa_payoh;
    	if( dgroup.getLocation().contains( "Woodlands" ) ) return R.drawable.woodlands;
    	if( dgroup.getLocation().contains( "Yishun" ) ) return R.drawable.yishun;
		return R.drawable.singapore;
	}

	protected static class ViewHolder{
        public TextView title;
        public TextView contact;
        public TextView day;
        public TextView time;
        public TextView group;
        public NetworkImageView image;
        public ImageView backupImage;

        public ViewHolder(View root){
        	title = (TextView) root.findViewById( R.id.textview_title );
        	contact = (TextView) root.findViewById( R.id.textview_contact );
        	day = (TextView) root.findViewById( R.id.textview_day );
        	time = (TextView) root.findViewById( R.id.textview_time );
        	group = (TextView) root.findViewById( R.id.textview_group );
        	image = (NetworkImageView) root.findViewById( R.id.imageview_image );
        	backupImage = (ImageView) root.findViewById( R.id.imageview_image_backup );
        }
    }
}