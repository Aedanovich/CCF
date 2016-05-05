package com.ccfsg.connect.beans;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class VimeoDetail implements Parcelable {

	private String title;
	private String description;
	private int id;
	private String uploadDate;
	private String thumbnailSmall;
	private String thumbnailMedium;
	private String thumbnailLarge;
	private String duration;
	private String mobileUrl;
	
	public VimeoDetail( JSONObject json )
	{
		try
		{
			title = json.has( "title" ) ? json.getString( "title" ) : "";
			description = json.has( "description" ) ? json.getString( "description" ) : "";
			uploadDate = json.has( "upload_date" ) ? json.getString( "upload_date" ) : "";
			mobileUrl = json.has( "mobile_url" ) ? json.getString( "mobile_url" ) : "";
			thumbnailSmall = json.has( "thumbnail_small" ) ? json.getString( "thumbnail_small" ) : "";
			thumbnailMedium = json.has( "thumbnail_medium" ) ? json.getString( "thumbnail_medium" ) : "";
			thumbnailLarge = json.has( "thumbnail_large" ) ? json.getString( "thumbnail_large" ) : "";
			duration = json.has( "duration" ) ? json.getString( "duration" ) : "";
			id = json.has( "id" ) ? json.getInt( "id" ) : 0;
		}
		catch( JSONException e )
		{
			e.printStackTrace();
		}
	}
	
	@Override
	public int describeContents() {
		return 0;
	}
    
    @Override
    public void writeToParcel(Parcel out, int i) 
    {
    	out.writeString(title);
    	out.writeString(description);
    	out.writeString(uploadDate);
    	out.writeString(mobileUrl);
    	out.writeString(thumbnailSmall);
    	out.writeString(thumbnailMedium);
    	out.writeString(thumbnailLarge);
    	out.writeString(duration);
    	out.writeInt(id);
    }
    
    public VimeoDetail(Parcel in)
    {
    	title = in.readString();
    	description = in.readString();
    	uploadDate = in.readString();
    	mobileUrl = in.readString();
    	thumbnailSmall = in.readString();
    	thumbnailMedium = in.readString();
    	thumbnailLarge = in.readString();
    	duration = in.readString();
        id = in.readInt();
    }
    
    public static final Parcelable.Creator<VimeoDetail> CREATOR = new Parcelable.Creator<VimeoDetail>() {
        public VimeoDetail createFromParcel(Parcel in) {
            return new VimeoDetail(in);
        }

        public VimeoDetail[] newArray(int size) {
            return new VimeoDetail[size];
        }
    };
	
	public String getTitle()
	{
		return title;
	}
	
	public String getDescription()
	{
		return description;
	}
	
	public String getUploadDate()
	{
		return uploadDate;
	}
	
	public String getThumbnailSmall()
	{
		return thumbnailSmall;
	}
	
	public String getThumbnailMedium()
	{
		return thumbnailMedium;
	}
	
	public String getThumbnailLarge()
	{
		return thumbnailLarge;
	}
	
	public int getId()
	{
		return id;
	}
	
	public String getDuration()
	{
		return duration;
	}
	
	public String getMobileUrl()
	{
		return mobileUrl;
	}
	
	public static ArrayList<VimeoDetail> toArrayList( JSONArray array )
	{
		ArrayList<VimeoDetail> details = new ArrayList<VimeoDetail>();
		try
		{
			for( int i = 0; i < array.length(); i++ )
			{
				VimeoDetail detail = new VimeoDetail( array.getJSONObject( i ) );
				details.add( detail );
			}
		}
		catch( JSONException e )
		{
			e.printStackTrace();
		}
		return details;
	}
}
