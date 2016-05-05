package com.ccfsg.connect.beans;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

public class VimeoVideo implements Parcelable {

	private String title;
	private String url;
	private String mobileUrl;
	
	public VimeoVideo( JSONObject json )
	{
		try
		{
			title = json.has("video") ? (json.getJSONObject("video").has("title") ? json.getJSONObject("video").getString("title") : "") : "";
			url = json.has("video") ? (json.getJSONObject("video").has("url") ? json.getJSONObject("video").getString("url") : "") : "";
			mobileUrl = json.getJSONObject("request").getJSONObject("files").getJSONObject("hls").getString("url");
			url = mobileUrl;
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
    	out.writeString(url);
    	out.writeString(mobileUrl);
    }
    
    public VimeoVideo(Parcel in)
    {
    	title = in.readString();
    	url = in.readString();
    	mobileUrl = in.readString();
    }
    
    public static final Parcelable.Creator<VimeoVideo> CREATOR = new Parcelable.Creator<VimeoVideo>() {
        public VimeoVideo createFromParcel(Parcel in) {
            return new VimeoVideo(in);
        }

        public VimeoVideo[] newArray(int size) {
            return new VimeoVideo[size];
        }
    };
	
	public String getTitle()
	{
		return title;
	}
	
	public String getUrl()
	{
		return url;
	}
	
	public String getMobileUrl()
	{
		return mobileUrl;
	}
}