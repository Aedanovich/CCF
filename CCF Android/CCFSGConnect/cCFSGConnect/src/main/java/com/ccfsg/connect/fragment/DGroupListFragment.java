package com.ccfsg.connect.fragment;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ProgressBar;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.ccfsg.connect.R;
import com.ccfsg.connect.adapter.DgroupListAdapter;
import com.ccfsg.connect.api.DGroupApi;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.DGroup;

public class DGroupListFragment extends Fragment {
    public static final String TAG = "DgroupListFragment";
    private AdapterView listView;
    private ArrayList<DGroup> dgroupList;
    private ProgressBar progressBar;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    	actionBar.setTitle( getString( R.string.dgroups ).toUpperCase() );
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root;
        
        root = inflater.inflate(R.layout.fragment_dgroup_list, container, false);
        listView = (AdapterView) root.findViewById(R.id.listview);
        progressBar = (ProgressBar) root.findViewById( R.id.progress_bar );
        dgroupList = new ArrayList<DGroup>();
        return root;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceStates){
        super.onActivityCreated(savedInstanceStates);
        execute();
    }

    private void renderContent()
    {
        Collections.sort(dgroupList, new DGroupComparator());
    	DgroupListAdapter adapter = new DgroupListAdapter(getActivity(), dgroupList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() 
        {
            @Override
            public void onItemClick(android.widget.AdapterView<?> adapterView, View view, int position, long id)
            {
            	DGroup dgroup = (DGroup) listView.getItemAtPosition(position);
            	Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
    			emailIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    			emailIntent.setType("vnd.android.cursor.item/email");
    			emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[] { dgroup.getEmail() });
    			emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "I want to join this Dgroup: " + dgroup.getLocation() + " led by " + dgroup.getContact() );
    			emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, "Name:\nContact Info:");
    			startActivity(Intent.createChooser(emailIntent, "Send mail using..."));
            }
        });
        listView.setVisibility(View.VISIBLE);
    }
    
    public void execute() 
    {
    	try 
    	{
    		DGroupApi.Query query = DGroupApi.getList( getActivity() );
			VolleyManager.makeVolleyStringRequest(getActivity(), query, new Response.Listener<String>() 
        		{
                    @Override
                    public void onResponse(String response) 
                    {
                        if (isDetached()) return;
                        try 
                        {
                        	JSONObject jsonObject = new JSONObject( response );
                    		String banner = jsonObject.has( "banner" ) ? jsonObject.getString( "banner" ) : "";
                        	JSONArray jsonArray = jsonObject.getJSONArray( "data" );
                        	for( int i = 0; i < jsonArray.length(); i++ )
                        	{
                        		JSONObject json = jsonArray.getJSONObject( i );
                        		String group = json.has( "group" ) ? json.getString( "group" ) : "";
                        		JSONArray locationArray = json.has( "locations" ) ? json.getJSONArray( "locations" ) : null;
                        		if( locationArray != null )
                        		{
                        			for( int j = 0 ; j < locationArray.length(); j++ )
                        			{
                                		JSONObject locJson = locationArray.getJSONObject( j );
                                		DGroup dgroup = new DGroup( locJson );
                                		dgroup.setGroup( group );
                                		dgroup.setBanner( banner );
                                		dgroupList.add( dgroup );
                        			}
                        		}
                        	}
                            progressBar.setVisibility( View.GONE );
                            renderContent();
                        } 
                        catch (Exception e) 
                        {
                        	e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error)
                    {
                    	error.printStackTrace();
                    }
                }
            );
		}
    	catch (Exception e)
		{
			e.printStackTrace();
		}
    }

    class DGroupComparator implements Comparator<DGroup> {
        @Override
        public int compare(DGroup o1, DGroup o2) {
            return o1.getLocation().compareTo(o2.getLocation());
        }
    }
}