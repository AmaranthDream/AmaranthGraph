/*Класс для построения графиков функции Amaranth Dream 2012 г.*/
package  {
	
	import flash.display.*;
	
	
	public class AGraph extends MovieClip {
		
		private var aheight:Number; //Высота графика
		private var awidth:Number;	//Ширина графика
		
		private var ahmin:Number;	//минимальное значение по горизонтальной оси
		private var ahmax:Number;	//максимальное значение по горизонтальной оси
		private var awmin:Number;	//минимальное значение по вертикальной оси
		private var awmax:Number;	//максимальное значение по вертикальной оси
		
		private var a_axis:Sprite; 	//Спрайт с осями
		private var a_greed:Sprite; //Спрайт с сеткой
		private var a_curve:Array; 	//Массив спрайтов с графиками
		
		
		const AXIS_LOG:String = 'axis_logarithmic';	//Константа для логарифмической оси
		const AXIS_LIN:String = 'axis_linear';		//Константа для линейной оси
		
		//Конструктор.
		//aheight - высота в пикселях(по умолчанию 100); 
		//awidht - ширина в пикселях (по умолчанию 100);
		//greed_type - тип сетки (по умолчанию линейная);
		//scale - масштаб графика (по умолчанию 10:1 px/единицу графика);
		public function AGraph(aheight:Number=100,awidth:Number=100,greed_type:String=AXIS_LIN,scale:Number=10) {
			trace(arguments);
			trace(aheight,awidth,greed_type);
		}
		
		//Отрисовка сетки
		private function agreed(){
			
		}
		
		//Отрисовка осей
		private function aaxis(){
			
		}
		
		//Отрисовка графиков
		private function acurve(){
			
		}
	}
	
}
