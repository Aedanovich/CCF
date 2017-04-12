package com.ccfsg.connect.beans;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VimeoVideo implements Parcelable {

	private String title;
	private String url;
	private String mobileUrl;
	private String embedCode;
	
	public VimeoVideo( JSONObject json )
	{
		try
		{
			title = json.has("video") ? (json.getJSONObject("video").has("title") ? json.getJSONObject("video").getString("title") : "") : "";
			embedCode = json.has("video") ? (json.getJSONObject("video").has("embed_code") ? json.getJSONObject("video").getString("embed_code") : "") : "";
			url = json.has("video") ? (json.getJSONObject("video").has("url") ? json.getJSONObject("video").getString("url") : "") : "";
			mobileUrl = json.getJSONObject("request").getJSONObject("files").getJSONArray("progressive").getJSONObject(0).getString("url");
			if (!embedCode.trim().isEmpty()) {
				Matcher matcher = Pattern.compile("src=\"([^\"]+)\"").matcher(embedCode);
				if (matcher.find()) {
					//url = matcher.group(1) + "?autoplay=1&title=0&byline=0&portrait=0";
					embedCode = "<iframe src=\"" + matcher.group(1) + "?autoplay=1&title=0&byline=0&portrait=0\" width=\"100%\" height=\"97%\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>";
				}
			}
			//url = mobileUrl;
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

	public String getEmbedCode() { return embedCode.trim().isEmpty() ? "" : "<html><body>" + embedCode + "</body></html>"; }
}