package model;

import java.util.EventListener;

public interface TimerExpiredListener extends EventListener {
	void aTimerHasExpired(String username);
}
