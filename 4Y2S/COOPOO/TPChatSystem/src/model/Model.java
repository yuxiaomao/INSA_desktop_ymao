package model;


import javax.swing.DefaultListModel;

import contact.Contact;

public class Model {
    
	private DefaultListModel<Contact> userList;
    private Contact local_user;
    
    public Model(Contact _user){
       this.userList = new DefaultListModel<Contact>();
       this.local_user = _user;
    }
    
    public Contact getLocalUser(){
        return local_user;
    }
    
    public void setNameLocalUser(String name){
        local_user.setUsername(name);
    }
    
    public DefaultListModel<Contact> getRemoteUsers(){
        return this.userList;
    }
    
    /*
     * Add a remote User to the list of Connected users
     */
    public void addRemoteUser(Contact r_user){
        if (!this.userList.contains(r_user)){
        	this.userList.addElement(r_user);
        }
        System.out.println(this.userList.toString());
    }
    
    /*
     * Delete a remote User to the list of Connected users
     */
    public void delRemoteUser(Contact r_user){
        this.userList.removeElement(r_user);
        System.out.println(this.userList.toString());
    }

    /*
     * Check if the user is in the list (identified by it's IP address)
     */
    public Contact checkRemoteUser (String hostaddr){
        Contact r = null;
        Contact r_user=null;
        for(int i=0;i<this.userList.size();i++){
        	r_user=this.userList.getElementAt(i);
            if (r_user.getIp().equals(hostaddr))
                r = r_user;
        }
        return r;
    }
    
    /*
     * Check if the user is in the list (identified by it's username)
     */
    public Contact checkRemoteUserName (String username)
    {
        Contact r = null;
        Contact r_user=null;
        for(int i=0;i<this.userList.size();i++){
        	r_user=this.userList.getElementAt(i);
            if (r_user.getUsername().equals(username))
                r = r_user;
        }
        return r;
    }
}
