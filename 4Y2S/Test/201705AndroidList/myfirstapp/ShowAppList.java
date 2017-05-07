package com.example.ymao.myfirstapp;

import android.app.Activity;
import android.app.LoaderManager;
import android.content.CursorLoader;
import android.content.Intent;
import android.content.Loader;
import android.database.Cursor;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class ShowAppList extends Activity implements LoaderManager.LoaderCallbacks<Cursor>{

    public final static String EXTRA_MESSAGE_TYPE = "com.example.ymao.myfirstapp.ShowAppList.MESSAGE";

    // This is the Adapter being used to display the list's data
    SimpleCursorAdapter mAdapter;
    ApplicationDAO appDB;
    private ApplicationType type = null;

    static final String[] PROJECTION = new String[] {ApplicationDAO.APP_KEY, ApplicationDAO.APP_NAME,
                                    ApplicationDAO.APP_TYPE, ApplicationDAO.APP_VERSION};
    // This is the select criteria
    static final String SELECTION = ApplicationDAO.APP_TYPE + " = ? ";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.d("ShowAppList","Call onCreate");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show_app_list);

        Intent intent = getIntent();
        this.type = (ApplicationType) intent.getSerializableExtra(ShowAppList.EXTRA_MESSAGE_TYPE);

        // set Title
        TextView label = (TextView)findViewById(R.id.label_showapplist);
        label.setText(this.type.toString());

        // For the cursor adapter, specify which columns go into which views
        String[] fromColumns = {ApplicationDAO.APP_KEY, ApplicationDAO.APP_NAME, ApplicationDAO.APP_TYPE, ApplicationDAO.APP_VERSION};
        int[] toViews = {R.id.app_key, R.id.app_name, R.id.app_type, R.id.app_version}; // The TextView in simple_list_item_1

        // Create an empty adapter we will use to display the loaded data.
        mAdapter = new SimpleCursorAdapter(this,R.layout.list_element_entry, null, fromColumns, toViews, 0);
        ListView list1 = (ListView) findViewById(R.id.app_list_view);
        list1.setAdapter(mAdapter);

        // Prepare the loader.  Either re-connect with an existing one,
        // or start a new one.
        getLoaderManager().initLoader(0, null, this);
    }

    @Override
    // Called when a new Loader needs to be created
    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        Log.d("ShowAppList","Call onCreateLoader");
        String[] selectionArgs = {this.type.toString()};
        CursorLoader cl = new CursorLoader(this, ApplicationDAO.CONTENT_URI, PROJECTION, SELECTION, selectionArgs, null);
        return cl;
    }

    @Override
    // Called when a previously created loader has finished loading
    public void onLoadFinished(Loader<Cursor> loader, Cursor data) {
        Log.d("ShowAppList","Call onLoadFinished");
        // Swap the new cursor in.  (The framework will take care of closing the
        // old cursor once we return.)
        mAdapter.swapCursor(data);
    }

    @Override
    // Called when a previously created loader is reset, making the data unavailable
    public void onLoaderReset(Loader<Cursor> loader) {
        Log.d("ShowAppList","Call onLoaderReset");
        // This is called when the last Cursor provided to onLoadFinished()
        // above is about to be closed.  We need to make sure we are no
        // longer using it.
        mAdapter.swapCursor(null);
    }

    public void chooseGame(View view){
        Intent intent = new Intent(this, ShowAppList.class);
        intent.putExtra(ShowAppList.EXTRA_MESSAGE_TYPE, ApplicationType.GAME);
        startActivity(intent);
        finish();
    }

    public void chooseOther(View view){
        Intent intent = new Intent(this, ShowAppList.class);
        intent.putExtra(ShowAppList.EXTRA_MESSAGE_TYPE, ApplicationType.OTHER);
        startActivity(intent);
        finish();
    }
}
