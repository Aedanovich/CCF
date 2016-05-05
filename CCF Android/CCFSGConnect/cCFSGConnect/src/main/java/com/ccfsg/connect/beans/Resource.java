package com.ccfsg.connect.beans;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class Resource implements Parcelable {

	private String name;
	private String verse;
	private String details;
	private String image;
	private String file;
	private String publisher;
	private String date;
	
	public Resource( JSONObject json )
	{
		try
		{	
			name = json.has( "name" ) ? json.getString( "name" ) : "";
			verse = json.has( "verse" ) ? json.getString( "verse" ) : "";
			details = json.has( "details" ) ? json.getString( "details" ) : "";
			image = json.has( "image" ) ? json.getString( "image" ) : "";
			file = json.has( "file" ) ? json.getString( "file" ) : "";
			publisher = json.has( "publisher" ) ? json.getString( "publisher" ) : "";
			date = json.has( "date" ) ? json.getString( "date" ) : "";
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
    	out.writeString(file);
    	out.writeString(publisher);
    	out.writeString(date);
    }
    
    public Resource(Parcel in)
    {
    	name = in.readString();
    	verse = in.readString();
    	details = in.readString();
    	image = in.readString();
    	file = in.readString();
    	publisher = in.readString();
    	date = in.readString();
    }
    
    public static final Parcelable.Creator<Resource> CREATOR = new Parcelable.Creator<Resource>() {
        public Resource createFromParcel(Parcel in) {
            return new Resource(in);
        }

        public Resource[] newArray(int size) {
            return new Resource[size];
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
	
	public String getPublisher()
	{
		return publisher;
	}
	
	public String getFile()
	{
		return file;
	}
	
	public String getDate()
	{
		return date;
	}
	
	public static ArrayList<Resource> toArrayList( JSONArray array )
	{
		ArrayList<Resource> details = new ArrayList<Resource>();
		try
		{
			for( int i = 0; i < array.length(); i++ )
			{
				Resource detail = new Resource( array.getJSONObject( i ) );
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