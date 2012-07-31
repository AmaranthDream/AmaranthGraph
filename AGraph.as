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
		private var a_back:Sprite=new Sprite(); //Спрайт с фоном
		
		const AXIS_LOG:String = 'axis_logarithmic';	//Константа для логарифмической оси
		const AXIS_LIN:String = 'axis_linear';		//Константа для линейной оси
		const AXIS_HALF_LOG:String = 'axis_half_log'; //Константа для полулогарифмической оси
		
		//Конструктор.
		//height - высота в пикселях(по умолчанию 100); 
		//widht - ширина в пикселях (по умолчанию 100);
		//greed_type - тип сетки (по умолчанию линейная);
		//scale - масштаб сетки (по умолчанию 10:1 px/единицу графика);
		//hmin, hmax, wmin, wmax - Минимальныие и максимальные значение по осям соответственно
		public function AGraph(	height:Number=400,
								width:Number=400,
								greed_type:String=AXIS_HALF_LOG,
								scale:Number=100,
								hmin:Number=0,
								hmax:Number=100,
								wmin:Number=0,
								wmax:Number=100) {
			aheight=height;
			awidth=width;
			ahmin=hmin;
			ahmax=hmax;
			awmin=wmin;
			awmax=wmax;
			
			//ToDo построение фона---
			a_back.graphics.lineStyle(0,0x000000);
			a_back.graphics.beginFill(0xFFFFFF);
			a_back.graphics.drawRect(0,0,awidth,aheight);
			a_back.graphics.endFill();
			addChild(a_back);
			// end ToDo---
			
			//вызов сетки.
			agreed(greed_type,scale,10);
			
		}
		
		//Отрисовка сетки. gtype - тип сетки, scalx, scaly - горизонтальный и вертикальный масштаб.
		private function agreed(gtype:String,scalx:Number,scaly:Number){

			a_greed=new Sprite();
			addChild(a_greed);
			
			//Функция рисовки линейной сетки scaleX, scaleY горизонтальный и вертикальный масштаб
			
			//рисовка вертикальных линий сетки с интервалом scaleX
			function alinhgreed(scaleX:Number){ 
				//ToDo: Сделать диалог настроки стиля
				a_greed.graphics.lineStyle(0.1,0x000000); //Стиль линии 
				a_greed.graphics.beginFill(0x00FF00);
				if(scaleX>0){	//Если 0 то вертикальные линии не строить			
					for (var i :Number=0;i<=aheight;i+=scaleX){ //рисовка вертикальных линий сетки с интервалом scaleX
						a_greed.graphics.moveTo(i,0);
						a_greed.graphics.lineTo(i,aheight);
					}
				}
				a_greed.graphics.endFill();
			}
			
			//рисовка горизонтальных линий сетки c интервалом scaleY
			function alinwgreed(scaleY:Number){ 
				a_greed.graphics.lineStyle(0.1,0x000000); //Стиль линии 
				a_greed.graphics.beginFill(0x00FF00);
				if(scaleY>0){ //если 0 то горизонтальные линии не строить
					for (var i:Number=0;i<=awidth;i+=scaleY){ //рисовка горизонтальных линий сетки c интервалом scaleY
						a_greed.graphics.moveTo(0,i);
						a_greed.graphics.lineTo(awidth,i);
					}
				}
				a_greed.graphics.endFill();
			}
			
			//Вычисляет десятичный логарифм числа х
			function lg(x:Number):Number{
				return Math.log(x)/Math.log(10);
			}
			
			//Фуркция рисовки логарифмической сетки. ScaleX, scaleY масштаб пикселей/декаду
			/// ToDo Сделать маскирование выходящих линий логарифмической сетки
			
			//Рисовка вертикальной логарифмической сетки с масштабом scaleX пикселей на декаду.
			function aloghgreed(scaleX:Number){
				var current_value:Number=0;
				a_greed.graphics.lineStyle(0.1,0x999999); //Стиль линии 
				a_greed.graphics.beginFill(0x00FF00);
				for(var i:Number=0;i<=aheight/scaleX;i++){ //Вертикальные линии
					for (var j :Number=1;j<11;j++){
						a_greed.graphics.moveTo(current_value+scaleX*lg(j),0);
						a_greed.graphics.lineTo(current_value+scaleX*lg(j),aheight);
					}
					current_value=current_value+scaleX*lg(j-1);
				}
				a_greed.graphics.endFill();
			}
			
			//Рисовка горизонтальной логарифмической сетки с масштабом scaleY пикселей на декаду.
			function alogwgreed(scaleY:Number){
				var current_value:Number=0;
				a_greed.graphics.lineStyle(0.1,0x999999); //Стиль линии 
				a_greed.graphics.beginFill(0x00FF00);
				for (var i:Number=0;i<=awidth/scaleY;i++){ //горизонтальные линии
					for (var j:Number=1;j<11;j++){
						a_greed.graphics.moveTo(0,aheight-(current_value+scaleY*lg(j)));
						a_greed.graphics.lineTo(awidth,aheight-(current_value+scaleY*lg(j)));
					}
					current_value=current_value+scaleY*lg(j-1);
				}
				a_greed.graphics.endFill();
			} 
			
			//Выбор метода отрисовки, и рисовка сетки
			switch (gtype){
			case AXIS_LIN: alinhgreed(scalx); alinwgreed(scaly); break;
			case AXIS_LOG: aloghgreed(scalx);alogwgreed(scaly); break;
			case AXIS_HALF_LOG : aloghgreed(scalx); alinwgreed(scaly); break;
			}
		}
		
		//Отрисовка осей
		private function aaxis(){
			
		}
		
		//Отрисовка графиков
		private function acurve(){
			
		}
	}
	
}
