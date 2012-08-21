/*Класс для построения графиков функции Amaranth Dream 2012 г.*/

/*ToDo : сделать диалоги настройки сетки, осей, и графиков
сделать удаление графика из массива
Вычислить зависимость размера маркеров от шрифта
сделать маркеры для квадратных осей
Вывест коэффициент Логарифмического преобразования
Замаскировать все выходы из зоны рисования или же предотвратить эти выходы*/
package  {
	
	import flash.display.*;
	import fl.controls.*;
	import flash.text.*;
	
	public class AGraph extends MovieClip {
		
		private var myFormat:TextFormat = new TextFormat();	//Формат текста для маркеров
		
		private var aheight:Number; 				//Высота графика
		private var awidth:Number;				//Ширина графика
		
		private var ahmin:Number;				//минимальное значение по вертикальной оси
		private var ahmax:Number;				//максимальное значение по вертикальной оси
		private var awmin:Number;				//минимальное значение по горизонтальной оси
		private var awmax:Number;				//максимальное значение по горизонтальной оси
		
		private var zero_X:Number;				//Абсолютная Координата x Нуля на графике
		private var zero_Y:Number; 				//Координата у Нуля
		
		private var a_quan_greed_w:Number; 			//количество вертикальных линий сетки и меток на осях
		private var a_quan_greed_h:Number; 			// -//- горизонтальных
		
		private var a_axis:Shape=new Shape(); 			//Спрайт с осями
		private var marks:Array=[]; 				//Массив для маркеров (Номерки на осях)
		private var a_greed:Shape=new Shape(); 		//Спрайт с сеткой
		private var a_curve:Array=[]; 				//Массив спрайтов с графиками
		private var a_functions:Array=[];			//Массив с функциями, графики которых будут строится
		private var a_back:Shape=new Shape(); 			//Спрайт с фоном
		
		private var current_greed:String; 			//текущий вид сетки
		private var current_axis:String;			//Текущий вид осей
		
		const AXIS_LOG:String = 'axis_logarithmic';		//Константа для логарифмической оси
		const AXIS_LIN:String = 'axis_linear';			//Константа для линейной оси
		const AXIS_HALF_LOG:String = 'axis_half_log'; 		//Константа для полулогарифмической оси
		
		const V_AXIS_CROSS:String = 'view_axis_cross'; 	//Вид осей Крест
		const V_AXIS_SQUARE:String = 'view_axis_square'; 	//Вид осей квадрат.
		
		//Конструктор.
		//height - высота в пикселях(по умолчанию 400); 
		//widht - ширина в пикселях (по умолчанию 400);
		//hmin, hmax, wmin, wmax - Минимальныие и максимальные значение по осям соответственно
 		//greed_type - тип сетки (по умолчанию линейная);
		//axis_type - тип осей (по умолчанию скрещенные);
		public function AGraph(	height:Number=400,
					width:Number=400,
					hmin:Number=-10,
					hmax:Number=10,
					wmin:Number=-10,wmax:Number=10,
					greed_type:String=AXIS_LIN,
					axis_type:String=V_AXIS_CROSS){
					
			aheight=height;
			awidth=width;
			ahmin=hmin;
			ahmax=hmax;
			awmin=wmin;
			awmax=wmax;		
			
			current_greed=greed_type;
			current_axis=axis_type;
			
			//Формат указателей.
			myFormat.font = "Consolas";
			myFormat.size=16;
			myFormat.bold=true;
			myFormat.color=0x0000FF;
			myFormat.align='center'
					
			//ToDo построение фона---этот используется как маска.
			a_back.graphics.lineStyle(0,0x000000);
			a_back.graphics.beginFill(0xFFFFFF);
			a_back.graphics.drawRect(0,0,awidth,aheight);
			a_back.graphics.endFill();
			addChild(a_back);
			// end ToDo---
			
			addChild(a_greed);//добавление пустой сетки
			addChild(a_axis);//добавление пустых осей
			rebild();
			
		}
		
		public function rebild(){
			//Автосетка
			a_quan_greed_w=Math.round(awidth/50);
			a_quan_greed_h=Math.round(aheight/50);
			
			aaxis(current_axis);//рисовка осей
			agreed(current_greed);//рисовка сетки
			acurve();//график 1
			adiag();//справка
		}
		
		public function addFunction(F:Function){
		  a_curve.push(new Shape);
		  a_functions.push(F);
		}
		
		//Отрисовка сетки. gtype - тип сетки
		private function agreed(gtype:String){

			a_greed.graphics.clear();
			alingreed();
			//Функция рисовки линейной сетки
			function alingreed(){
				var IntW:Number=awidth/a_quan_greed_w;
				var IntH:Number=aheight/a_quan_greed_h;
				a_greed.graphics.lineStyle(0.1,0xAAAAAA); //Стиль линии 
				for (var s:Number=zero_X;s<=awidth;s+=IntW){//Горизонтальные линии
					a_greed.graphics.moveTo(s,0);
					a_greed.graphics.lineTo(s,aheight);
				}
				for (s=zero_X;s>=0;s-=IntW){
					a_greed.graphics.moveTo(s,aheight);
					a_greed.graphics.lineTo(s,0);
				}
				for (s=zero_Y;s>=0;s-=IntH){//Вертикальные линии
					a_greed.graphics.moveTo(0,s);
					a_greed.graphics.lineTo(awidth,s);
				}
				for (s=zero_Y;s<=aheight;s+=IntH){
					a_greed.graphics.moveTo(0,s);
					a_greed.graphics.lineTo(awidth,s);
				}
			}

			//Вычисляет десятичный логарифм числа х
			function lg(x:Number):Number{
				return Math.log(x)/Math.log(10);
			}
			
			/*//Фуркция рисовки логарифмической сетки. ScaleX, scaleY масштаб пикселей/декаду
			/// ToDo Сделать маскирование выходящих линий логарифмической сетки
			
			//Рисовка вертикальной логарифмической сетки с масштабом scaleX пикселей на декаду.
			function aloghgreed(scaleX:Number){
				var current_value:Number=0;
				a_greed.graphics.lineStyle(0.1,0xAAAAAA); //Стиль линии 
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
				a_greed.graphics.lineStyle(0.1,0xAAAAAA); //Стиль линии 
				a_greed.graphics.beginFill(0x00FF00);
				for (var i:Number=0;i<=awidth/scaleY;i++){ //горизонтальные линии
					for (var j:Number=1;j<11;j++){
						a_greed.graphics.moveTo(0,aheight-(current_value+scaleY*lg(j)));
						a_greed.graphics.lineTo(awidth,aheight-(current_value+scaleY*lg(j)));
					}
					current_value=current_value+scaleY*lg(j-1);
				}
				a_greed.graphics.endFill();
			} */
		}
		
		//Отрисовка осей
		private function aaxis(axis_type:String){
			
			
			a_axis.graphics.clear();
			function axissquare(){//Рисовка квадтарных осей
				a_axis.graphics.lineStyle(1,0x000000);
				a_axis.graphics.beginFill(0xFFFFFF,0);
				a_axis.graphics.drawRect(0,0,awidth,aheight);
				a_axis.graphics.endFill();
			}
			
			function axiscross(){//Рисовка скрещенных осей О_о
				
				//поиск координат нуля
				function findzero(){
				
					zero_X=-awmin*awidth/(awmax-awmin);
					zero_Y=ahmax*aheight/(ahmax-ahmin);
					trace('Х нуля ',zero_X);
					trace('Y нуля ',zero_Y);
				}
				findzero();
				with(a_axis.graphics){
				lineStyle(1,0xFF0000);
				beginFill(0xFF0000);
				drawCircle(zero_X,zero_Y,1);//Начало координат		
				moveTo(zero_X,zero_Y);
				lineTo(zero_X,0);
				lineTo(zero_X-2,7);//Вертикальная стрелка
				lineTo(zero_X+2,7);
				lineTo(zero_X,0);
				
				moveTo(zero_X,zero_Y);
				lineTo(0,zero_Y);
				moveTo(zero_X,zero_Y);
				lineTo(zero_X,aheight);
				lineTo(zero_X,aheight);
				moveTo(zero_X,zero_Y);
				
				lineTo(awidth,zero_Y);//горизонтальная стрелка
				lineTo(awidth-7,zero_Y+2);
				lineTo(awidth-7,zero_Y-2);
				lineTo(awidth,zero_Y);
				
				endFill();
				}
				//Удаление старых меток
				marks.forEach(function(element:*, index:int, arr:Array):void{
					removeChild(element);
				});
				marks=[];
				var IntW:Number=awidth/a_quan_greed_w;
				var IntH:Number=aheight/a_quan_greed_h;
				var j:Number;
				for (var s:Number=zero_X;s<=awidth;s+=IntW){//Горизонтальные ризки
					a_axis.graphics.moveTo(s,zero_Y+2);
					a_axis.graphics.lineTo(s,zero_Y-2);
					j=marks.push(new Label());
					j-=1;
					trace('Ширина лейбла №',j,' - ',marks[j].width);
					trace('высота лейбла №',j,' - ',marks[j].height);
					marks[j].text=(Math.round(100*((s/(awidth/(awmax-awmin))-(zero_X/(awidth/(awmax-awmin))))))/100).toString();
					if(marks[j].text=='0'){marks[j].text='';}
					marks[j].setStyle("textFormat", myFormat);
					marks[j].x=s-IntW;
					marks[j].alpha=0.4;
					marks[j].y=zero_Y-20;
					addChild(marks[j]);
				}
				for (s=zero_X;s>=0;s-=IntW){
					a_axis.graphics.moveTo(s,zero_Y+2);
					a_axis.graphics.lineTo(s,zero_Y-2);
					j=marks.push(new Label());
					j-=1;
					marks[j].text=(Math.round(100*((s/(awidth/(awmax-awmin))-(zero_X/(awidth/(awmax-awmin))))))/100).toString();
					if(marks[j].text=='0'){marks[j].text='';}
					marks[j].setStyle("textFormat", myFormat);
					marks[j].x=s-IntW;
					marks[j].alpha=0.4;
					marks[j].y=zero_Y-20;
					addChild(marks[j]);
				}
				for (s=zero_Y;s>=0;s-=IntH){//Вертикальные ризки
					a_axis.graphics.moveTo(zero_X+2,s);
					a_axis.graphics.lineTo(zero_X-2,s);
					j=marks.push(new Label());
					j-=1;
					marks[j].text=(Math.round(100* (-(s/(aheight/(ahmax-ahmin))-(zero_Y/(aheight/(ahmax-ahmin))))))/100).toString();
					if(marks[j].text=='0'){marks[j].text='';}
					marks[j].setStyle("textFormat", myFormat);
					marks[j].x=zero_X-11;
					marks[j].alpha=0.4;
					marks[j].y=s-11;
					addChild(marks[j]);
				}
				for (s=zero_Y;s<=aheight;s+=IntH){
					a_axis.graphics.moveTo(zero_X+2,s);
					a_axis.graphics.lineTo(zero_X-2,s);
					j=marks.push(new Label());
					j-=1;
					marks[j].text=(Math.round(100* (-(s/(aheight/(ahmax-ahmin))-(zero_Y/(aheight/(ahmax-ahmin))))))/100).toString();
					if(marks[j].text=='0'){marks[j].text='';}
					marks[j].setStyle("textFormat", myFormat);
					marks[j].x=zero_X-11;
					marks[j].alpha=0.4;
					marks[j].y=s-11;
					addChild(marks[j]);
				}
			}
			axiscross();//вызов сетки
		}
		
		//Отрисовка графиков
		public function acurve(){
			var l:Number=a_curve.length;
			var step:Number=(awmax-awmin)/(awidth); //Шаг, обратная ему величина есть коэффициент приведения горизонтальной оси
			var Ycoeff:Number=aheight/(ahmax-ahmin); //Коэффициент приведения вертикальной оси Y=y*k
			trace("Шаг определён как ",step);
			trace(a_curve);
			for (var n:Number=0;n<l;n++){
			      addChild(a_curve[n]);
			      a_curve[n].graphics.clear();
			      a_curve[n].mask=a_back;
			     trace(n,'+======================+');
			      a_curve[n].graphics.lineStyle(1,0x000000);
			      a_curve[n].graphics.moveTo((awmin/step)+zero_X,-(a_functions[n](awmin))*Ycoeff+zero_Y); //Перемещение указателя на начало графика
			      for(var i:Number=awmin;i<=awmax;i+=step){
				      a_curve[n].graphics.lineTo((i/step)+zero_X,-(a_functions[n](i))*Ycoeff+zero_Y);
			      }
			}
		}
		
		//Просмотр свойств
		private function adiag(){
			trace('------------------------------\nВывод основных данных графика:\n');
			trace('Длина - ',awidth,'Высота - ', aheight);
			trace('Диапазон  по горизонтали (',awmin,':',awmax,')');
			trace('Диапазон  по вертикали (',ahmin,':',ahmax,')');
			trace('Абсолютные координаты нуля (x;y) - (',zero_X,';',zero_Y,')');
			trace('Количество вертикальных линий сетки:',a_quan_greed_w,' Горизонтальных:',a_quan_greed_h);
			trace('Количество графиков: ',a_curve.length);
			trace();
			trace('------------------------------');
		}
	}
	
}
