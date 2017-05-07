package com.example.ymao.myfirstapp;

import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

public class ApplicationDAO extends ContentProvider{

    protected final static int VERSION = 1;
    // nom du fichiier
    protected final static String NOM = "database.db";
    protected AppDBHandler mHandler = null;


    public static final String APP_TABLE_NAME = "ALL_APP";

    //public static class ListColumns implements BaseColumns{
    public static final String APP_KEY = "_id";
    public static final String APP_NAME = "name";
    public static final String APP_TYPE = "type";
    public static final String APP_VERSION = "version";

    private static final String TEXT_TYPE = " TEXT";
    private static final String COMMA_SEP = ",";

    public static final String APP_TABLE_CREATE =
            "CREATE TABLE " + APP_TABLE_NAME + " (" +
                    APP_KEY + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    APP_NAME + TEXT_TYPE + COMMA_SEP +
                    APP_TYPE + TEXT_TYPE + COMMA_SEP +
                    APP_VERSION + TEXT_TYPE + ");";
    private static final String APP_TABLE_DROP =
            "DROP TABLE IF EXISTS " + APP_TABLE_NAME + ";";


    static final String PROVIDER_NAME = "com.example.ymao.myfirstapp.ApplicationDAO";
    static final String URL = "content://" + PROVIDER_NAME + "/apps";
    static final Uri CONTENT_URI = Uri.parse(URL);

    private static final int APPLICATION = 1;
    private static final int APPLICATION_ID = 2;

    private static final UriMatcher sURIMatcher = new UriMatcher(UriMatcher.NO_MATCH);

    static
    {
        sURIMatcher.addURI(PROVIDER_NAME, APP_TABLE_NAME, APPLICATION);
        sURIMatcher.addURI(PROVIDER_NAME, APP_TABLE_NAME+"/#", APPLICATION_ID);
    }


    public void add(Application app){
        SQLiteDatabase mDb = mHandler.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(APP_NAME, app.getNom());
        values.put(APP_TYPE, app.getType().toString());
        values.put(APP_VERSION, app.getVersion());

        // Insert the new row, returning the primary key value of the new row
        long newRowId = mDb.insert(APP_TABLE_NAME, null, values);
    }

    public void initTableForTest(){
        SQLiteDatabase mDb = mHandler.getWritableDatabase();
        mDb.execSQL(APP_TABLE_DROP);
        mDb.execSQL(APP_TABLE_CREATE);

        this.add(new Application("Super Meat Boy",ApplicationType.GAME,"v1.0"));
        this.add(new Application("The Binding of Isaac",ApplicationType.GAME,"v2.0"));
        this.add(new Application("Meteo France",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Eclipse",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Chrome",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Skyrim",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Chld of Light",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Watch Dogs",ApplicationType.GAME,"v1.0"));
        this.add(new Application("My cafe",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Sky Force",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Skype",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Android Studio",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Gmail",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Google Drive",ApplicationType.OTHER,"v2.0"));
        this.add(new Application("Facebook",ApplicationType.OTHER,"v1.0"));
        this.add(new Application("Cytus",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Steam",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Prune",ApplicationType.GAME,"v1.0"));
        this.add(new Application("Music",ApplicationType.OTHER,"v1.0"));

        Log.d("ApplicationDAO", "After insert appdb");
    }

    @Override
    public boolean onCreate() {
        Context context = getContext();
        this.mHandler = new AppDBHandler(context, NOM, null, VERSION);
        SQLiteDatabase mDb = mHandler.getWritableDatabase();
        this.initTableForTest();
        return (mDb == null)? false:true;
    }

    @Nullable
    @Override
    public Cursor query(@NonNull Uri uri, @Nullable String[] projection, @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder) {
        SQLiteDatabase mDb = mHandler.getReadableDatabase();

        Log.d("ApplicationDAO","Call query"+uri.toString()+"/"+projection.toString()+"/"+selection);

        Cursor c = mDb.query(APP_TABLE_NAME,projection,selection,selectionArgs,null,null,sortOrder);
        c.setNotificationUri(getContext().getContentResolver(), uri);
        return c;
    }

    @Nullable
    @Override
    public String getType(@NonNull Uri uri) {
        switch (sURIMatcher.match(uri)) {
            case APPLICATION:
                return PROVIDER_NAME+"/apps";
            case APPLICATION_ID:
                return PROVIDER_NAME+"/apps/#";
            default:
        }
        return null;
    }

    @Nullable
    @Override
    public Uri insert(@NonNull Uri uri, @Nullable ContentValues values) {
        SQLiteDatabase mDb = mHandler.getWritableDatabase();

        // Insert the new row, returning the primary key value of the new row
        long newRowId = mDb.insert(APP_TABLE_NAME, null, values);

        // if add succes
        if (newRowId > 0) {
            Uri _uri = ContentUris.withAppendedId(CONTENT_URI, newRowId);
            getContext().getContentResolver().notifyChange(_uri, null);
            return _uri;
        }

        throw new SQLException("Failed to add a App into " + uri);
    }

    @Override
    public int delete(@NonNull Uri uri, @Nullable String selection, @Nullable String[] selectionArgs) {
        SQLiteDatabase mDb = mHandler.getWritableDatabase();
        return mDb.delete(APP_TABLE_NAME, selection, selectionArgs);
    }

    @Override
    public int update(@NonNull Uri uri, @Nullable ContentValues values, @Nullable String selection, @Nullable String[] selectionArgs) {
        return 0;
    }
}
