package  {
	
	import flash.display.MovieClip;
	import flash.sensors.Accelerometer;
	
	
	public class axes extends MovieClip {
		public var g:AGraph;
		
		public function axes() {
			// constructor code
			g=new AGraph();
			addChild(g);
			g.x=10;
			g.y=10;
		}
		
	}
	
}
