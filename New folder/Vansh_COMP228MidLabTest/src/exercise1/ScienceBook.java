package exercise1;
import javax.swing.JOptionPane;

class ScienceBook extends Book  {
	
	 public ScienceBook(String title, String ISBN, String publisher, int year) {
	        super(title, ISBN, publisher, year);
	    }
	 public void setPrice(double price) {
	        this.price = price * 0.9; // 10% discount for science books
	    }

	    public String getGenre() {
	        return "Science";
	    }
 }

