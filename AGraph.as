/*Класс для построения графиков функции Amaranth Dream 2012 г.*/

/*ToDo : сделать диалоги настройки сетки, осей, и графиков
сделать массив графиков с динамическим добавлением.
Маркеры заменить одним массивом
Вывест коэффициент Логарифмического преобразования
Замаскировать все выходы из зоны рисования или же предотвратить эти выходы*/
package  {
	
	import flash.display.*;
	import fl.controls.*;
	import flash.text.*;
	
	public class AGraph extends MovieClip {
		
		private var myFormat:TextFormat = new TextFormat();
		
		private var aheight:Number; //Высота графика
		private var awidth:Number;	//Ширина графика
		
		private var ahmin:Number;	//минимальное значение по вертикальной оси
		private var ahmax:Number;	//максимальное значение по вертикальной оси
		private var awmin:Number;	//минимальное значение по горизонтальной оси
		private var awmax:Number;	//максимальное значение по горизонтальной оси
		
		private var zero_X:Number;	//Абсолютная Координата x Нуля на графике
		private var zero_Y:Number; //Координата у Нуля
		
		private var a_quan_greed_w:Number; //количество вертикальных линий сетки и меток на осях
		private var a_quan_greed_h:Number; // -//- горизонтальных
		
		private var a_axis:Shape=new Shape(); 	//Спрайт с осями
		private var a_greed:Shape=new Shape(); //Спрайт с сеткой
		private var a_curve:Array=[new Shape(),new Shape(),new Shape(),new Shape()]; 	//Массив спрайтов с графиками
		private var a_back:Shape=new Shape(); //Спрайт с фоном
		
		const AXIS_LOG:String = 'axis_logarithmic';	//Константа для логарифмической оси
		const AXIS_LIN:String = 'axis_linear';		//Константа для линейной оси
		const AXIS_HALF_LOG:String = 'axis_half_log'; //Константа для полулогарифмической оси
		
		const V_AXIS_CROSS:String = 'view_axis_cross'; //Вид осей Крест
		const V_AXIS_SQUARE:String = 'view_axis_square'; //Вид осей квадрат.
		
		//Конструктор.
		//height - высота в пикселях(по умолчанию 100); 
		//widht - ширина в пикселях (по умолчанию 100);
		//greed_type - тип сетки (по умолчанию линейная);
		//axis_type - тип осей (по умолчанию скрещенные);
		//hmin, hmax, wmin, wmax - Минимальныие и максимальные значение по осям соответственно
		public function AGraph(	height:Number=400,
								width:Number=400,
								greed_type:String=AXIS_LOG,
								axis_type:String=V_AXIS_CROSS,
								hmin:Number=-10,
								hmax:Number=10,
								wmin:Number=5,wmax:Number=10){
			aheight=height;
			awidth=width;
			ahmin=hmin;
			ahmax=hmax;
			awmin=wmin;
			awmax=wmax;		
			//Формат указателей.
			myFormat.font = "Impact";
			myFormat.size=14;
			myFormat.color=0x0000FF;
			myFormat.align='center'
			
			//Автосетка
			a_quan_greed_w=Math.round(awidth/50);
			a_quan_greed_h=Math.round(aheight/50);
			
			//ToDo построение фона---этот используется как маска.
			a_back.graphics.lineStyle(0,0x000000);
			a_back.graphics.beginFill(0xFFFFFF);
			a_back.graphics.drawRect(0,0,awidth,aheight);
			a_back.graphics.endFill();
			addChild(a_back);
			// end ToDo---
			addChild(a_greed);//добавление пустой сетки
			addChild(a_axis);//добавление пустых осей
			
			
			aaxis(axis_type);//рисовка осей
			agreed(greed_type);//рисовка сетки
			adiag();//справка
			acurve(A,0);//график 1
			acurve(A1,1);//график 2
			
		}
		
		//Отрисовка сетки. gtype - тип сетки
		private function agreed(gtype:String){

			
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
				a_axis.graphics.lineStyle(1,0xFF0000);
				findzero();
				a_axis.graphics.beginFill(0xFF0000);
				a_axis.graphics.drawCircle(zero_X,zero_Y,1);//Начало координат		
				a_axis.graphics.moveTo(zero_X,zero_Y);
				a_axis.graphics.lineTo(zero_X,0);
				a_axis.graphics.lineTo(zero_X-2,7);//Вертикальная стрелка
				a_axis.graphics.lineTo(zero_X+2,7);
				a_axis.graphics.lineTo(zero_X,0);
				
				a_axis.graphics.moveTo(zero_X,zero_Y);
				a_axis.graphics.lineTo(0,zero_Y);
				a_axis.graphics.moveTo(zero_X,zero_Y);
				a_axis.graphics.lineTo(zero_X,aheight);
				a_axis.graphics.lineTo(zero_X,aheight);
				a_axis.graphics.moveTo(zero_X,zero_Y);
				
				a_axis.graphics.lineTo(awidth,zero_Y);//горизонтальная стрелка
				a_axis.graphics.lineTo(awidth-7,zero_Y+2);
				a_axis.graphics.lineTo(awidth-7,zero_Y-2);
				a_axis.graphics.lineTo(awidth,zero_Y);
				
				a_axis.graphics.endFill();
				var IntW:Number=awidth/a_quan_greed_w;
				var IntH:Number=aheight/a_quan_greed_h;
				for (var s:Number=zero_X;s<=awidth;s+=IntW){//Горизонтальные ризки
					a_axis.graphics.moveTo(s,zero_Y+2);
					a_axis.graphics.lineTo(s,zero_Y-2);
					var labb:Label=new Label();
					labb.text=(Math.round(100*((s/(awidth/(awmax-awmin))-(zero_X/(awidth/(awmax-awmin))))))/100).toString();
					if(labb.text=='0'){labb.text='';}
					labb.setStyle("textFormat", myFormat);
					labb.x=s-IntW;
					labb.alpha=0.4;
					labb.y=zero_Y-20;
					addChild(labb);
				}
				for (s=zero_X;s>=0;s-=IntW){
					a_axis.graphics.moveTo(s,zero_Y+2);
					a_axis.graphics.lineTo(s,zero_Y-2);
					var labb2:Label=new Label();
					labb2.text=(Math.round(100*((s/(awidth/(awmax-awmin))-(zero_X/(awidth/(awmax-awmin))))))/100).toString();
					if(labb2.text=='0'){labb2.text='';}
					labb2.setStyle("textFormat", myFormat);
					labb2.x=s-IntW;
					labb2.alpha=0.4;
					labb2.y=zero_Y-20;
					addChild(labb2);
				}
				for (s=zero_Y;s>=0;s-=IntH){//Вертикальные ризки
					a_axis.graphics.moveTo(zero_X+2,s);
					a_axis.graphics.lineTo(zero_X-2,s);
					var labb3:Label=new Label();
					labb3.text=(-(s/(aheight/(ahmax-ahmin))-(zero_Y/(aheight/(ahmax-ahmin))))).toString();
					if(labb3.text=='0'){labb3.text='';}
					labb3.setStyle("textFormat", myFormat);
					labb3.x=zero_X-35;
					labb3.alpha=0.4;
					labb3.y=s-12;
					addChild(labb3);
				}
				for (s=zero_Y;s<=aheight;s+=IntH){
					a_axis.graphics.moveTo(zero_X+2,s);
					a_axis.graphics.lineTo(zero_X-2,s);
					var labb4:Label=new Label();
					labb4.text=(-(s/(aheight/(ahmax-ahmin))-(zero_Y/(aheight/(ahmax-ahmin))))).toString();
					if(labb4.text=='0'){labb4.text='';}
					labb4.setStyle("textFormat", myFormat);
					labb4.x=zero_X-35;
					labb4.alpha=0.4;
					labb4.y=s-12;
					addChild(labb4);
				}
			}
			axiscross();//вызов сетки
		}
		
		//тестовая функция для передачи параметра в отрисовку
		public var A:Function= function(x:Number):Number{
			return 5*(1-Math.exp(-0.2*x));
		}
		//тестовая функция для передачи параметра в отрисовку
		public var A1:Function= function(x:Number):Number{
			return 10*(Math.sin(x));
		}
		
		//Отрисовка графиков
		private function acurve(F:Function,n:Number){
			
			addChild(a_curve[n]);
			a_curve[n].mask=a_back;
			var step:Number=(awmax-awmin)/(awidth); //Шаг, обратная ему величина есть коэффициент приведения горизонтальной оси
			var Ycoeff:Number=aheight/(ahmax-ahmin); //Коэффициент приведения вертикальной оси Y=y*k
			trace("Шаг определён как ",step);
			a_curve[n].graphics.lineStyle(1,0x000000);
			
			a_curve[n].graphics.moveTo((awmin/step)+zero_X,-(F(awmin))*Ycoeff+zero_Y); //Перемещение указателя на начало графика
			for(var i:Number=awmin;i<=awmax;i+=step){
				a_curve[n].graphics.lineTo((i/step)+zero_X,-(F(i))*Ycoeff+zero_Y);
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
			trace();
			trace('------------------------------');
		}
	}
	
}
