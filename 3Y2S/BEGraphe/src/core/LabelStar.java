package core;

//Label special pour PccStar
public class LabelStar extends Label {
	
	private double coutEstimee;

	public LabelStar(boolean marquage, float cout, int pere, int sommet_courant, double coutEstimee) {
		super(marquage, cout, pere, sommet_courant);
		this.coutEstimee = coutEstimee;
	}

	public double getCoutEstimee() {
		return coutEstimee;
	}
	
	// comparer avec cout+coutEstimee, dans le cas d'egalite, prendre coutEstimee plus petite
	public int compareTo(Label o) {
		if (o instanceof LabelStar){
			double diff = this.getCout() + this.coutEstimee - o.getCout() - ((LabelStar)o).getCoutEstimee();
			if (diff ==0.0f){
				if(this.coutEstimee < ((LabelStar)o).getCoutEstimee()){
					return -1;
				}else{
					return 1;
				}
			}else if(diff > 0.0f){
				return 1;// doute si int0.1=0ou1
			}else{
				return -1;
			}
		}else{
			return super.compareTo(o);
		}

	}
}
