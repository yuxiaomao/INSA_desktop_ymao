import java.util.Date;

public class LogLine {

	/**   */
	private Date date;

	private String message;

	private Robot emetteur;

	private Robot tiers;

	/** Constructeur */
	public LogLine(String message, Robot emetteur, Robot tiers) {
		this.date = new Date();
		this.message = message;
		this.emetteur = emetteur;
		this.tiers = tiers;
	}

	/** Getteur */
	public Date getDate() {
		return this.date;
	}

	public Robot getEmetteur() {
		return this.emetteur;
	}

	public Robot getTiers() {
		return this.tiers;
	}

	public String toString() {
		return this.date + this.message + this.emetteur + this.tiers;
	}

}
