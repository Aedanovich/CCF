package com.ccfsg.connect.beans;

public class Menu {
	private String text;
	private int image;
	
	public Menu( String text, int image )
	{
		this.text = text;
		this.image = image;
	}
	
	public String getText()
	{
		return text;
	}
	
	public int getImage()
	{
		return image;
	}
}
