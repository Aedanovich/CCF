package com.ccfsg.connect.beans;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class DGroup implements Parcelable {

	private String group;
	private String banner;
	private String location;
	private String contact;
	private String day;
	private String time;
	private String email;
	private String addressName;
	private String image;
	private int longitude;
	private int latitude;
	private int agerangemin;
	private int agerangemax;
	
	public DGroup( JSONObject json )
	{
		try
		{	
			location = json.has( "location" ) ? json.getString( "location" ) : "";
			contact = json.has( "contact" ) ? json.getString( "contact" ) : "";
			day = json.has( "day" ) ? json.getString( "day" ) : "";
			time = json.has( "time" ) ? json.getString( "time" ) : "";
			email = json.has( "email" ) ? json.getString( "email" ) : "";
			addressName = json.has( "addressname" ) ? json.getString( "addressname" ) : "";
			image = json.has( "imageurl" ) ? json.getString( "imageurl" ) : "";
			longitude = json.has( "longitude" ) ? json.getInt( "longitude" ) : 0;
			latitude = json.has( "latitude" ) ? json.getInt( "latitude" ) : 0;
			agerangemin = json.has( "agerangemin" ) ? json.getInt( "agerangemin" ) : 0;
			agerangemax = json.has( "agerangemax" ) ? json.getInt( "agerangemax" ) : 0;
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
    	out.writeString(group);
    	out.writeString(banner);
    	out.writeString(location);
    	out.writeString(contact);
    	out.writeString(day);
    	out.writeString(time);
    	out.writeString(email);
    	out.writeString(addressName);
    	out.writeString(image);
    	out.writeInt(longitude);
    	out.writeInt(latitude);
    	out.writeInt(agerangemin);
    	out.writeInt(agerangemax);
    }
    
    public DGroup(Parcel in)
    {
    	group = in.readString();
    	banner = in.readString();
    	location = in.readString();
    	contact = in.readString();
    	day = in.readString();
    	time = in.readString();
    	email = in.readString();
    	addressName = in.readString();
    	image = in.readString();
    	longitude = in.readInt();
    	latitude = in.readInt();
    	agerangemin = in.readInt();
    	agerangemax = in.readInt();
    }
    
    public static final Parcelable.Creator<DGroup> CREATOR = new Parcelable.Creator<DGroup>() {
        public DGroup createFromParcel(Parcel in) {
            return new DGroup(in);
        }

        public DGroup[] newArray(int size) {
            return new DGroup[size];
        }
    };
	
	public String getGroup()
	{
		return group;
	}
	
	public String getLocation()
	{
		return location;
	}
	
	public String getContact()
	{
		return contact;
	}
	
	public String getImage()
	{
		return image;
	}
	
	public String getDay()
	{
		return day;
	}
	
	public String getTime()
	{
		return time;
	}
	
	public int getLatitude()
	{
		return latitude;
	}
	
	public int getLongitude()
	{
		return longitude;
	}
	
	public String getAddressName()
	{
		return addressName;
	}
	
	public String getEmail()
	{
		return email;
	}
	
	public int getAgeRangeMin()
	{
		return agerangemin;
	}
	
	public int getAgeRangeMax()
	{
		return agerangemax;
	}
	
	public String getBanner()
	{
		return banner;
	}
	
	public void setGroup( String group )
	{
		this.group = group;
	}

	public void setBanner( String banner )
	{
		this.banner = banner;
	}
}
