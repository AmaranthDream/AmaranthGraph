package  {
	
	import flash.display.MovieClip;
	import flash.sensors.Accelerometer;
	import fl.controls.*;
	import flash.events.*;
	
	public class axes extends MovieClip {
		public var g:AGraph;
		public var but:Button=new Button();
		public static var tin:TextInput=new TextInput();
		public static var tin2:TextInput=new TextInput();
		public function axes() {
			// constructor code
			addChild(but);
			but.x=50;
			but.y=450;
			addChild(tin);
			tin.y=450;
			tin.x=150;
			tin.text='5';
			addChild(tin2);
			tin2.y=450;
			tin2.x=250;
			tin2.text='5';
			
			trace(parseFloat(tin.text));
			g=new AGraph(300,300,-50,50,-50,50);
			addChild(g);
			g.x=10;
			g.y=10;
			
			but.addEventListener(MouseEvent.MOUSE_DOWN,rbild);
			g.addFunction(A);
			g.addFunction(A2);
			//g.rebild();
		}
		
		public function rbild(e:Event){
			g.rebild();
		}
			
		//тестовая функция для передачи параметра в отрисовку
		public var A:Function= function(x:Number):Number{		
			return parseFloat(tin.text)*(Math.sin(x+parseFloat(tin2.text)));
		}
		
		public var A2:Function= function(x:Number):Number{
			return parseFloat(tin.text)*(1-Math.exp(-parseFloat(tin2.text)/10*x));
		}
	}
	
}
