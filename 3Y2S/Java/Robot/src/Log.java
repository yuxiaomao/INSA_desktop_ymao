import java.util.*;

public class Log {

	private Stack<LogLine> pileLog;

	public Log() {
		this.pileLog = new Stack<LogLine>();
	}

	public void add(String message, Robot emetteur, Robot tiers) {
		pileLog.push(new LogLine(message, emetteur, tiers));
	}

	public LogLine trouveLigne(Robot emetteur, Robot tiers) throws PasTrouve {
		LogLine resu = null;
		for (Iterator<LogLine> it = pileLog.iterator(); it.hasNext();) {
			LogLine ligne = it.next();
			if (((ligne.getEmetteur() == emetteur) && (ligne.getTiers() == tiers))
					|| ((ligne.getEmetteur() == tiers) && (ligne.getTiers() == emetteur))) {
				// return ligne;
				resu = ligne;
			}
		}
		if (resu == null) {
			throw (new PasTrouve("message"));
		} else {
			return resu;
		}
		// throw (new PasTrouve("message")) ;
	}

	public String toString() {
		String s = new String();
		for (LogLine ligne : pileLog) {
			s = s + ligne + "\n";
		}
		return s;
	}

}
