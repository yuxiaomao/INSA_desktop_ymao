CursorTreeAdapter cursorTreeAdapter = new CursorTreeAdapter(matrixCursor,getActivity()) {
    @Override
    protected Cursor getChildrenCursor(Cursor groupCursor) {
        Cursor cursor;
        int item = groupCursor.getInt(groupCursor.getColumnIndex("_id"));
        if (item == 1){
            cursor = myContentProvider.query(MyContentProvider.CONTENT_URI_BOITIER_2_CHARGES,null,Integer.toString(id),null,null);
        }else{
            cursor = myContentProvider.query(MyContentProvider.CONTENT_URI_BOITIER_2_INTERRUPTEURS,null,Integer.toString(id),null,null);
        }
        return cursor;
    }

    @Override
    protected View newGroupView(Context context, Cursor cursor, boolean isExpanded, ViewGroup parent) {
        LayoutInflater layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        return layoutInflater.inflate(R.layout.simple_list_item_header,parent,false);
    }

    @Override
    protected void bindGroupView(View view, Context context, Cursor cursor, boolean isExpanded) {
        TextView textView = (TextView) view.findViewById(R.id.list_item_header);
        textView.setText(cursor.getString(cursor.getColumnIndex("item")));
        if (isExpanded) {
            view.setBackgroundColor(context.getResources().getColor(R.color.colorListHeaderBgExpanded));
        } else{
            view.setBackgroundColor(context.getResources().getColor(R.color.colorListHeaderBg));
        }
    }

    @Override
    protected View newChildView(Context context, Cursor cursor, boolean isLastChild, ViewGroup parent) {
        LayoutInflater layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        return layoutInflater.inflate(R.layout.simple_list_item_charge,parent,false);
    }

    @Override
    protected void bindChildView(View view, Context context, Cursor cursor, boolean isLastChild) {
        String s;
        TextView textView;

        s = cursor.getString(cursor.getColumnIndex("_id"));
        textView = (TextView) view.findViewById(R.id.list_item_charge_id);
        textView.setText(s);
        s = cursor.getString(cursor.getColumnIndex("item"));
        textView = (TextView) view.findViewById(R.id.list_item_charge_item);
        textView.setText(s);
        s = cursor.getString(cursor.getColumnIndex("description"));
        textView = (TextView) view.findViewById(R.id.list_item_charge_description);
        textView.setText(s);
        s = cursor.getString(cursor.getColumnIndex("status"));
        textView = (TextView) view.findViewById(R.id.list_item_charge_status);
        textView.setText(s);
    }
};