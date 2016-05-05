package com.ccfsg.connect.beans;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class Ministry implements Parcelable {

	private String name;
	private String verse;
	private String details;
	private String image;
	private String email;
	
	public Ministry( JSONObject json )
	{
		try
		{	
			name = json.has( "name" ) ? json.getString( "name" ) : "";
			verse = json.has( "verse" ) ? json.getString( "verse" ) : "";
			details = json.has( "details" ) ? json.getString( "details" ) : "";
			image = json.has( "image" ) ? json.getString( "image" ) : "";
			email = json.has( "email" ) ? json.getString( "email" ) : "";
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
    	out.writeString(verse);
    	out.writeString(details);
    	out.writeString(image);
    	out.writeString(email);
    }
    
    public Ministry(Parcel in)
    {
    	name = in.readString();
    	verse = in.readString();
    	details = in.readString();
    	image = in.readString();
    	email = in.readString();
    }
    
    public static final Parcelable.Creator<Ministry> CREATOR = new Parcelable.Creator<Ministry>() {
        public Ministry createFromParcel(Parcel in) {
            return new Ministry(in);
        }

        public Ministry[] newArray(int size) {
            return new Ministry[size];
        }
    };
	
	public String getName()
	{
		return name;
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
	
	public String getEmail()
	{
		return email;
	}
	
	public static ArrayList<Ministry> toArrayList( JSONArray array )
	{
		ArrayList<Ministry> details = new ArrayList<Ministry>();
		try
		{
			for( int i = 0; i < array.length(); i++ )
			{
				Ministry detail = new Ministry( array.getJSONObject( i ) );
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
