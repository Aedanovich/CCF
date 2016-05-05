package com.ccfsg.connect.beans;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class Event implements Parcelable {

	private String name;
	private String subname;
	private String venue;
	private String memberPrice;
	private String guestPrice;
	private String date;
	private String startTime;
	private String endTime;
	private String verse;
	private String details;
	private String image;
	private String form;
	
	public Event( JSONObject json )
	{
		try
		{
			name = json.has( "name" ) ? json.getString( "name" ) : "";
			subname = json.has( "subname" ) ? json.getString( "subname" ) : "";
			venue = json.has( "venue" ) ? json.getString( "venue" ) : "";
			memberPrice = json.has( "memberprice" ) ? json.getString( "memberprice" ) : "";
			guestPrice = json.has( "guestprice" ) ? json.getString( "guestprice" ) : "";
			date = json.has( "date" ) ? json.getString( "date" ) : "";
			startTime = json.has( "starttime" ) ? json.getString( "starttime" ) : "";
			endTime = json.has( "endtime" ) ? json.getString( "endtime" ) : "";
			verse = json.has( "verse" ) ? json.getString( "verse" ) : "";
			details = json.has( "details" ) ? json.getString( "details" ) : "";
			image = json.has( "image" ) ? json.getString( "image" ) : "";
			form = json.has( "form" ) ? json.getString( "form" ) : "";
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
    	out.writeString(name);
    	out.writeString(subname);
    	out.writeString(venue);
    	out.writeString(memberPrice);
    	out.writeString(guestPrice);
    	out.writeString(date);
    	out.writeString(startTime);
    	out.writeString(endTime);
    	out.writeString(verse);
    	out.writeString(details);
    	out.writeString(image);
    	out.writeString(form);
    }
	
    public Event(Parcel in)
    {
    	name = in.readString();
    	subname = in.readString();
    	venue = in.readString();
    	memberPrice = in.readString();
    	guestPrice = in.readString();
    	date = in.readString();
    	startTime = in.readString();
    	endTime = in.readString();
    	verse = in.readString();
    	details = in.readString();
    	image = in.readString();
    	form = in.readString();
    }
    
    public static final Parcelable.Creator<Event> CREATOR = new Parcelable.Creator<Event>() {
        public Event createFromParcel(Parcel in) {
            return new Event(in);
        }

        public Event[] newArray(int size) {
            return new Event[size];
        }
    };
	
	public String getName()
	{
		return name;
	}
	
	public String getSubName()
	{
		return subname;
	}
	
	public String getVenue()
	{
		return venue;
	}
	
	public String getMemberPrice()
	{
		return memberPrice;
	}

	public String getGuestPrice()
	{
		return guestPrice;
	}
	
	public String getDate()
	{
		return date;
	}
	
	public String getStartTime()
	{
		return startTime;
	}
	
	public String getEndTime()
	{
		return endTime;
	}
	
	public String getVerse()
	{
		return verse;
	}
	
	public String getDetails()
	{
		return details;
	}
	
	public String getImage()
	{
		return image;
	}
	
	public String getForm()
	{
		return form;
	}
	
	public static ArrayList<Event> toArrayList( JSONArray array )
	{
		ArrayList<Event> details = new ArrayList<Event>();
		try
		{
			for( int i = 0; i < array.length(); i++ )
			{
				Event detail = new Event( array.getJSONObject( i ) );
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