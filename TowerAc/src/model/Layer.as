package model 
{
	import laya.ui.Image;
	public class Layer 
	{
		public var width:Number;
		public var layers:Number = 4;
		public var img:Image;
		public var layerIndex:Number; 
		public var pathIndex:Number; 
		 
		public var sideLPath:String = "ui/side/sidel.";
		public var sideRPath:String = "ui/side/sider.";
		public var unitPath:String = "ui/main/";
		public var heights:Array = [149, 197, 148, 159];
		public var sideWidth:Array = [80,100,150,90,90];
		public function Layer(_layerIndex:Number) 
		{ 
			img = new Image();
			layerIndex = _layerIndex;
			pathIndex = (layerIndex) % layers+1; 
			//img.skin = layerPath + pathIndex + ".png"; 
			//img.pivotX = img.width / 2; img.pivotY = img.height / 2;
		}
		 
		public function GetLayer(x:Number,y:Number,_width:Number):void{
			 width = _width;
			 if (pathIndex == 1)
			 { 
				 var unitwidth:Number =164/4; 
				 var num:Number = Math.floor(_width / unitwidth);
				 var yu:Number = _width % unitwidth;
				 
				  for (var j:int = 0; j <_width; j++ )
				 {
					 if ((j >= 0 && j < yu / 2) || (j >= _width-yu/ 2-4 && j < _width))
					 {
						var yushu:Image = new Image(); 
						//yushu.skin = unitPath + pathIndex + "bg.png";
						yushu.loadImage(unitPath + pathIndex + "bg.png");  
						yushu.scale(2, 0.25, true); 
						yushu.pivotY =Height/2;
						yushu.pos(j, 0);
						img.addChild(yushu); 
					 }
					 
				 }  
				 for (var i:int = 0; i < num; i++ )
				 {
					var u:Image = new Image();
					//u.skin = unitPath + pathIndex + ".png";
					u.loadImage(unitPath + pathIndex + ".png");  
					u.scale(0.25,0.25,true);
					u.pivotX = unitwidth / 2; u.pivotY =  Height / 2;
					u.pos(i*unitwidth+yu/2+4,0);
					img.addChild(u);
				 }  
				 
				 
			 } else if (pathIndex == 2)
			 { 
				 var unitwidth:Number =142/4;  
				 var num:Number = Math.floor(_width / unitwidth);
				 var yu:Number = _width % unitwidth;
				  for (var j:int = 0; j <_width; j++ )
				 {
					 if ((j >= 0 && j < yu / 2) || (j >= _width-yu/ 2-2-17/4 && j < _width))
					 {
						var yushu:Image = new Image(); 
						//yushu.skin = unitPath + pathIndex + "bg.png";
						yushu.loadImage(unitPath + pathIndex + "bg.png");  
						yushu.scale(2, 0.25, true); 
						yushu.pivotY =Height/2;
						yushu.pos(j,(197-149)/4);
						img.addChild(yushu); 
					 }
					 
				 }  
				 for (var i:int = 0; i < num; i++ )
				 {
					var u:Image = new Image();
					//u.skin = unitPath + pathIndex + ".png";
					u.loadImage(unitPath + pathIndex + ".png");  
					u.scale(0.25,0.25,true);
					u.pivotX = unitwidth / 2; u.pivotY = Height / 2; 
					u.pos(i*unitwidth+yu/2+2-17/4,0);
					img.addChild(u);
				 }  
				 
			 } else if (pathIndex == 3)
			 { 
				 var unitwidth:Number =164/4; 
				 var num:Number = Math.floor(_width / unitwidth);
				 var yu:Number = _width % unitwidth;
				  for (var j:int = 0; j <_width; j++ )
				 {
					 if ((j >= 0 && j < yu / 2) || (j >= _width-yu/ 2-4 && j < _width))
					 {
						var yushu:Image = new Image(); 
						//yushu.skin = unitPath + pathIndex + ".2"+ "bg.png";
						yushu.loadImage(unitPath + pathIndex + ".2"+ "bg.png");  
						yushu.scale(1, 0.25, true); 
						yushu.pivotY =Height/2;
						yushu.pos(j,0);
						img.addChild(yushu); 
					 }
					 
				 }  
				 for (var i:int = 0; i < num; i++ )
				 {
					var u:Image = new Image();
					//u.skin = unitPath + pathIndex +".2"+ ".png";
					u.loadImage(unitPath + pathIndex + ".2" + ".png");  
					u.scale(0.25,0.25,true);
					u.pivotX = unitwidth / 2; u.pivotY = Height / 2;
					u.pos(i*unitwidth+yu/2+4,0);
					img.addChild(u);
				 }  
				 
			 } else if (pathIndex == 4)
			 { 
				 var unitwidth:Number =164/4; 
				 var num:Number = Math.floor(_width / unitwidth);
				 var yu:Number = _width % unitwidth;
				  for (var j:int = 0; j <_width; j++ )
				 {
					 if ((j >= 0 && j < yu / 2) || (j >= _width-yu/ 2-4 && j < _width))
					 {
						var yushu:Image = new Image(); 
						//yushu.skin = unitPath + pathIndex + "bg.png";
						yushu.loadImage(unitPath + pathIndex + "bg.png");  
						yushu.scale(1, 0.25, true); 
						yushu.pivotY =Height/2;
						yushu.pos(j,0);
						img.addChild(yushu); 
					 }
					 
				 }  
				 for (var i:int = 0; i < num; i++ )
				 {
					var u:Image = new Image();
					//u.skin = unitPath + pathIndex + ".png";
					u.loadImage(unitPath + pathIndex + ".png");  
					u.scale(0.25,0.25,true);
					u.pivotX = unitwidth / 2; u.pivotY = Height / 2;
					u.pos(i*unitwidth+yu/2+4,0);
					img.addChild(u);
				 }  
			 }  
			  
			 img.x = x;
			 img.y = y;
			 
		}
		public var hasSide:Boolean = false;
		public function GetSide():void{
			if (width > 0)
			{
				hasSide = true;
				var imgY:Number = 0;
				 
				var scale:Number = 0.3;
				 
				var index:Number = Math.ceil(Math.random() * 5); 
				if (index == 5) imgY =Height / 2;
				if (index == 2) scale = 0.5;
				 
				
				if (Math.random() < 0.5)
				{
					if (index != 2&&index != 3)
					{
						var l:Image = new Image();
						//l.skin =sideLPath + index + ".png";
						l.loadImage(sideLPath + index + ".png");   
						l.scale(scale, scale, true);
						l.pos( (-sideWidth[index]*scale), imgY);
						img.addChild(l);
						hasLSide = true;
						trace(sideLPath + index + ".png");   
					} 
				}
				  
				if (Math.random() < 0.5)
				{
					var r:Image = new Image();
					//r.skin = sideRPath + index + ".png";
					r.loadImage(sideRPath + index + ".png");   
					r.scale(scale, scale, true); 
					r.pos(width, imgY);
					img.addChild(r); 
					hasRSide = true;
					trace(sideRPath + index + ".png");   
				}
				 
			}
			 
		}
		 
		public var hasLSide:Boolean = false;
		public var hasRSide:Boolean = false;
		 
		
		public function SetWidth(_width:Number):void{
			 width = _width;
		}
		public function get Height():Number{
			return heights[pathIndex-1]/4; 
		}
		
		public function   Clear():Number{
			img.removeChildren(0,width);
		}
	}

}