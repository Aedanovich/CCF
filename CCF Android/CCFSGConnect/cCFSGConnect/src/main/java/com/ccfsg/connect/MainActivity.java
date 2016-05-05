package com.ccfsg.connect;

import java.util.ArrayList;
import java.util.List;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.ccfsg.connect.adapter.MenuAdapter;
import com.ccfsg.connect.beans.FragmentItem;
import com.ccfsg.connect.beans.Menu;
import com.ccfsg.connect.fragment.AboutUsFragment;
import com.ccfsg.connect.fragment.DGroupListFragment;
import com.ccfsg.connect.fragment.EventListFragment;
import com.ccfsg.connect.fragment.ForumFragment;
import com.ccfsg.connect.fragment.HomeFragment;
import com.ccfsg.connect.fragment.MinistryListFragment;
import com.ccfsg.connect.fragment.OneYearBibleFragment;
import com.ccfsg.connect.fragment.ResourcesListFragment;
import com.ccfsg.connect.fragment.VideoFragment;
import com.ccfsg.connect.fragment.WorshipServiceRoomsFragment;
import com.ccfsg.connect.utils.ScreenUtils;

public class MainActivity extends ActionBarActivity implements OnItemClickListener {

    private static final String TAG = "MainActivity";
    private LinearLayout container; 
    private DrawerLayout drawerLayout;
    private ListView drawerListView;
    private ActionBarDrawerToggle drawerToggle;
    private MenuAdapter drawerItemAdapter;
    private String previousActionBarTitle = "";
    
    //This is to update the header after the drawer closes from click.  We don't update the header unless its clicked.
    private boolean isDrawerClicked;
    
    //This is to track which item is currently selected.
    private String selectedItem = null;
	
    @Override 
	public void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
		ScreenUtils.setCorrectOrientation( this );
		supportRequestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		setContentView(R.layout.activity_main);
        container = (LinearLayout) findViewById( R.id.container );
        try
        {
        	drawerLayout = (DrawerLayout) findViewById( R.id.drawer );
        }
        catch( Exception e )
        { 
        	
        }
        drawerListView = (ListView) findViewById( R.id.listview_drawer );
        initActionBar();
        initDrawer();
        renderHome();
	}

	private void initDrawer() 
	{
		drawerToggle = new ActionBarDrawerToggle(this, drawerLayout, R.drawable.ic_action_menu, R.string.app_name, R.string.app_name)
		{
            @Override
            public void onDrawerSlide(View view, float v) 
            {
            }
            @Override
            public void onDrawerOpened(View view)
            {
            	previousActionBarTitle = getSupportActionBar().getTitle() != null ? getSupportActionBar().getTitle().toString().toUpperCase() : null;
            	getSupportActionBar().setTitle( getString( R.string.menu ).toUpperCase() );
            }
            @Override
            public void onDrawerClosed(View view) 
            {
            	if( !isDrawerClicked )
            	{
	            	getSupportActionBar().setTitle( previousActionBarTitle );
	            }
            	
            	isDrawerClicked = false;
            }
			
            @Override
            public void onDrawerStateChanged(int i) {
            }
        };
        
        if( drawerLayout != null )
        {
	        drawerLayout.setDrawerShadow(R.drawable.drawer_shadow, GravityCompat.START);
	        drawerLayout.setDrawerListener(drawerToggle);
        }
		initDrawerContents();
		drawerListView.setOnItemClickListener( this );
	}

	private void initDrawerContents()
	{
		ArrayList<Menu> drawerItems = new ArrayList<Menu>();
		drawerItems.add( new Menu( getString( R.string.home ), R.drawable.icon_home ) );
		drawerItems.add( new Menu( getString( R.string.one_year_bible ), R.drawable.icon_bible ) );
		drawerItems.add( new Menu( getString( R.string.forums ), R.drawable.icon_forum ) );
		drawerItems.add( new Menu( getString( R.string.videos ), R.drawable.icon_video ) );
		drawerItems.add( new Menu( getString( R.string.dgroups ), R.drawable.icon_dg ) );
		drawerItems.add( new Menu( getString( R.string.events ), R.drawable.icon_events ) );
		drawerItems.add( new Menu( getString( R.string.ministries ), R.drawable.icon_serve ) );
		drawerItems.add( new Menu( getString( R.string.resources ), R.drawable.icon_resources ) );
		drawerItems.add( new Menu( getString( R.string.worship_service_rooms ), R.drawable.icon_worship_room ) );
		drawerItems.add( new Menu( getString( R.string.about_us ), R.drawable.icon_about_us ) );
		
		if( selectedItem == null )
		{
			drawerItemAdapter = new MenuAdapter( this, drawerItems );
			selectedItem = drawerItemAdapter.getItem( 1 ).getText();
		}
		else
		{
			int i = 0;
			for( Menu item : drawerItems )
			{
				if( item.getText().equals( selectedItem ) )
				{
					drawerItemAdapter = new MenuAdapter( this, drawerItems );
					selectedItem = drawerItemAdapter.getItem( i ).getText();
					break;
				}
				i++;
				
			}
		}
		drawerListView.setAdapter( drawerItemAdapter );
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) 
	{
		hideProgressBar();
		processDrawerClick( position );
	}

	private void processDrawerClick(int position)
	{	
		isDrawerClicked = true;
		
		if( drawerLayout != null )
		{
			drawerLayout.closeDrawer( drawerListView );
		}
		if( drawerListView.getSelectedItemPosition() != position )
		{
			renderDrawer( position );
		}
		
		selectedItem = drawerItemAdapter.getItem( position ).getText();
	}
    
	private void renderDrawer( int position )
	{	
		getSupportFragmentManager().popBackStack( null, FragmentManager.POP_BACK_STACK_INCLUSIVE );
		
		if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.home ) ) )
		{
			renderHome();
		}
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.videos ) ) )
		{
			renderVideo();
		}
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.dgroups ) ) )
		{
			renderDgroup();
		} 
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.forums ) ) )
		{
			renderForums();
		}
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.one_year_bible ) ) )
		{
			renderOneYearBible();
		}  
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.events ) ) )
		{
			renderEventList();
		}  
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.ministries ) ) )
		{
			renderMinistryList();
		}  
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.resources ) ) )
		{
			renderResource();
		}  
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.about_us ) ) )
		{
			renderAboutUs();
		}
		else if( drawerItemAdapter.getItem( position ).getText().equals( getString( R.string.worship_service_rooms ) ) )
		{
			renderWorshipServiceRooms();
		}
	}

	protected ActionBar initActionBar()
	{
        ActionBar actionBar = getSupportActionBar();
        if( ScreenUtils.isPhone( this ) )
        {
	        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD );
	        actionBar.setDisplayHomeAsUpEnabled( true );
	        actionBar.setDisplayShowHomeEnabled( true );
        }
        actionBar.setDisplayShowTitleEnabled(true);
        actionBar.setDisplayUseLogoEnabled(true);
        actionBar.setLogo(getResources().getDrawable(R.drawable.ic_launcher));
        actionBar.setIcon(getResources().getDrawable(R.drawable.ic_launcher));
        actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
        
        return actionBar;
    }
	
	@Override
    protected void onPostCreate(Bundle savedInstanceState)
	{
        super.onPostCreate(savedInstanceState);
        if( drawerLayout != null && drawerToggle != null ) drawerToggle.syncState();
    }
	
	@Override
    public void onBackPressed(){
        try
        {
        	if ( getVisibleFragment() instanceof ForumFragment )
        	{
        		ForumFragment fragment = (ForumFragment) getVisibleFragment();
        		if ( fragment.canBack() ) 
        		{
        			fragment.back();
        		}
        		else
        		{
        			renderHome();
        		}
        	}
        	else if ( getVisibleFragment() instanceof VideoFragment || 
    			getVisibleFragment() instanceof DGroupListFragment || 
    			getVisibleFragment() instanceof MinistryListFragment || 
    			getVisibleFragment() instanceof EventListFragment || 
    			getVisibleFragment() instanceof ResourcesListFragment || 
    			getVisibleFragment() instanceof AboutUsFragment )
        	{
        		renderHome();
        	}
        	else if ( getVisibleFragment() instanceof OneYearBibleFragment )
        	{
        		OneYearBibleFragment fragment = (OneYearBibleFragment) getVisibleFragment();
        		if ( fragment.canBack() ) 
        		{
        			fragment.back();
        		}
        		else
        		{
        			renderHome();
        		}
        	}
        	else if( getVisibleFragment() instanceof HomeFragment )
        	{
        		showQuestionToExit();
        	}
        	else
        	{
        		super.onBackPressed();
        	}
        }
        catch(Exception e)
        {
        	 return;
        }
    }

	private void showQuestionToExit() {
		new AlertDialog.Builder(this)
		    .setMessage(getString(R.string.exit_message))
		    .setCancelable(false)
		    .setPositiveButton(getString(R.string.yes), new DialogInterface.OnClickListener() {
		        public void onClick(DialogInterface dialog, int id) {
		            finish();
		        }
		    })
		    .setNegativeButton(getString(R.string.no), null)
		    .show();
	}
	
    public void renderHome() 
	{
		drawerItemAdapter.setSelectedItem( 0 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(HomeFragment.class, "home", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}
	
	public void renderOneYearBible()
	{
		drawerItemAdapter.setSelectedItem( 1 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
	
		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(OneYearBibleFragment.class, "home", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}

    public void renderForums() 
	{
		drawerItemAdapter.setSelectedItem( 2 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(ForumFragment.class, "home", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}

    public void renderVideo() 
	{
		drawerItemAdapter.setSelectedItem( 3 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(VideoFragment.class, "video", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}
    
    public void renderDgroup() 
	{
		drawerItemAdapter.setSelectedItem( 4 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(DGroupListFragment.class, "dgroup", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}
    
    public void renderEventList() 
	{
		drawerItemAdapter.setSelectedItem( 5 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(EventListFragment.class, "events", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}
    
    public void renderMinistryList() 
	{
		drawerItemAdapter.setSelectedItem( 6 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(MinistryListFragment.class, "ministry", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}
    
    public void renderResource() 
	{
		drawerItemAdapter.setSelectedItem( 7 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(ResourcesListFragment.class, "resource", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}

	public void renderWorshipServiceRooms()
	{
		drawerItemAdapter.setSelectedItem( 8 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(WorshipServiceRoomsFragment.class, "worship_service_rooms", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}

	public void renderAboutUs()
	{
		drawerItemAdapter.setSelectedItem( 9 );
		drawerItemAdapter.notifyDataSetChanged();
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

		Bundle extras = new Bundle();
		FragmentItem item = new FragmentItem(AboutUsFragment.class, "about_us", extras);
		item.createFragment( this );
		ft.replace(container.getId(), item.getFragment(), item.getTag());
		ft.commit();
	}
    
	public void popFragment() 
	{
		getSupportFragmentManager().popBackStack();
	}
	
	public Fragment getVisibleFragment()
	{
	    FragmentManager fragmentManager = getSupportFragmentManager();
	    List<Fragment> fragments = fragmentManager.getFragments();
	    for(Fragment fragment : fragments)
	    {
	        if(fragment != null && fragment.isVisible())
	            return fragment;
	    }
	    return null;
	}
	
	@Override
    public boolean onOptionsItemSelected(MenuItem item) 
	{
		if (item.getItemId() == android.R.id.home) 
		{
            if (drawerLayout.isDrawerOpen( drawerListView ))
            {
                drawerLayout.closeDrawer( drawerListView );
            } 
            else 
            {
                drawerLayout.openDrawer( drawerListView );
            }
        }
        else
        {
            super.onOptionsItemSelected(item);
        }
        return true;
	}
	
	public void showProgressBar()
	{
		setProgressBarIndeterminateVisibility(true);
	}
	
	public void hideProgressBar()
	{
		setProgressBarIndeterminateVisibility(false);
	}
}