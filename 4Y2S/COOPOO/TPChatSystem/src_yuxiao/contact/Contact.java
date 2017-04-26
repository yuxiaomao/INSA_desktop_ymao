package contact;

import java.awt.event.ActionListener;
import java.net.InetAddress;
import javax.swing.Timer;

public class Contact{
	private String username;
	private InetAddress ip;
	private State userState;
	private Timer timer;


	public Contact(String username, InetAddress ip, ActionListener action) {
		this.username = username;
		this.ip = ip;
		this.timer=new Timer(8000,action);
		this.userState=State.DISCONNECTED;
	}

	public void startTimer(){
		this.timer.start();
	}

	public void restartTimer(){
		this.timer.restart();
	}

	public void stopTimer(){
		this.timer.stop();
	}

	@Override
    public String toString()
    {
        return this.getUsername()+" : "+this.getIp();
    }

    @Override
    public boolean equals(Object o)
    {
        Contact u = null;
        if (o != null && o instanceof Contact){
            u = (Contact) o;
        }

        if(u != null)
            return ((this.ip.equals( u.getIp() ) ) );
        else
            return false;
    }

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public InetAddress getIp() {
		return ip;
	}

	public void setIp(InetAddress ip) {
		this.ip = ip;
	}

	public State getState() {
		return this.userState;
	}

	public void setState(State state) {
		this.userState = state;
	}

}
