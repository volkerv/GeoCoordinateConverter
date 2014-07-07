
public class TestData {

	public double latitude;
	public double longitude;
	public String utm;
	public String mgrs;
	public String name;

	public TestData( String name, double latitude, double longitude, String utm, String mgrs ) {
		
		this.name = name;
		this.latitude = latitude;
		this.longitude = longitude;
		this.utm = utm;
		this.mgrs = mgrs;
	}
}
