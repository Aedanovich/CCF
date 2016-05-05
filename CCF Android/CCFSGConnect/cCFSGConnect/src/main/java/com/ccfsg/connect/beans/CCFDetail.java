package com.ccfsg.connect.beans;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class CCFDetail implements Parcelable {

	private String text;
	private String value;
	
	public CCFDetail( JSONObject json )
	{
		try
		{	
			text = json.has( "text" ) ? json.getString( "text" ) : "";
			value = json.has( "value" ) ? json.getString( "value" ) : "";
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
    	out.writeString(text);
    	out.writeString(value);
    }
    
    public CCFDetail(Parcel in)
    {
    	text = in.readString();
    	value = in.readString();
    }
    
    public static final Parcelable.Creator<CCFDetail> CREATOR = new Parcelable.Creator<CCFDetail>() {
        public CCFDetail createFromParcel(Parcel in) {
            return new CCFDetail(in);
        }

        public CCFDetail[] newArray(int size) {
            return new CCFDetail[size];
        }
    };
	
	public String getText()
	{
		return text;
	}
	
	public String getValue()
	{
		return value;
	}
	
	public static ArrayList<CCFDetail> toArrayList( JSONArray array )
	{
		ArrayList<CCFDetail> details = new ArrayList<CCFDetail>();
		try
		{
			for( int i = 0; i < array.length(); i++ )
			{
				CCFDetail detail = new CCFDetail( array.getJSONObject( i ) );
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
