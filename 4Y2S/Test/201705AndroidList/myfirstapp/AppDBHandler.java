package com.example.ymao.myfirstapp;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;


public class AppDBHandler extends SQLiteOpenHelper {
    public static final String APP_KEY = "_id";
    public static final String APP_NAME = "name";
    public static final String APP_TYPE = "type";
    public static final String APP_VERSION = "version";

    private static final String TEXT_TYPE = " TEXT";
    private static final String COMMA_SEP = ",";
    public static final String APP_TABLE_NAME = "ALL_APP";
    public static final String APP_TABLE_CREATE =
            "CREATE TABLE " + APP_TABLE_NAME + " (" +
                    APP_KEY + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    APP_NAME + TEXT_TYPE + COMMA_SEP +
                    APP_TYPE + TEXT_TYPE + COMMA_SEP +
                    APP_VERSION + TEXT_TYPE + ");";
    private static final String APP_TABLE_DROP =
            "DROP TABLE IF EXISTS " + APP_TABLE_NAME + ";";


    public AppDBHandler(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
        super(context, name, factory, version);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(APP_TABLE_CREATE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // This database is only a cache for online data, so its upgrade policy is
        // to simply to discard the data and start over
        db.execSQL(APP_TABLE_DROP);
        onCreate(db);
    }
}
