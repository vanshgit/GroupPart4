package exercise1;

public class ChildrenBook extends Book {
	 public ChildrenBook(String title, String ISBN , String publisher , int year ) {
	        super ( title , ISBN , publisher , year);
	    }
   
	 // fixed price 
	    public void setPrice(double price) {
	        this.price = price; 
	    }

	    public String getGenre() {
	       return "Children";
	    }

}
