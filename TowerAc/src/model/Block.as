package model 
{
	import laya.d3.math.Vector3;
	import laya.ui.Image;
	import Mathf.ExQuaternion;
	import control.SceneManager;
	import control.TowerSys;
	import laya.filters.ColorFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class Block  
	{
		public var LR:Number =0;
		public var hoffset:Number =0;
		public var g:Number = 0.2;
		public var v:Number = 0;
		public var img:Image;
		public var width:Number;
		//public var height:Number=51;
		 
		
		public var layers:Number = 4;
		public var layerIndex:Number; 
		public var pathIndex:Number;  
		public var unitPath:String = "ui/main/";
		
		public var cutX:Number;
		public var cutWidth:Number;
		public var heights:Array = [149,197,148,159];
		public function Block(_width:Number,_layerIndex:Number) 
		{
			img = new Image();
			width = _width;
			layerIndex = _layerIndex;
			pathIndex = (layerIndex) % layers + 1; 
			 
			 
		}
		 
		 
		public function LoadImage():void{
			 
			var _width:Number = width;
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
					u.pivotX = unitwidth / 2; u.pivotY = Height / 2;
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
						yushu.loadImage(unitPath + pathIndex + "bg.png");  
						//yushu.skin = unitPath + pathIndex + "bg.png";
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
					trace(unitPath + pathIndex + ".png");
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
					//	yushu.skin = unitPath + pathIndex+ ".2" + "bg.png";
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
					u.loadImage(unitPath + pathIndex + ".2" + ".png");  
					//u.skin = unitPath + pathIndex + ".2"+ ".png";
					u.scale(0.25,0.25,true);
					u.pivotX = unitwidth / 2; u.pivotY = Height / 2;
					u.pos(i*unitwidth+yu/2+4,0);
					img.addChild(u);
					trace(unitPath +  pathIndex + ".2" + ".png");
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
						yushu.loadImage(unitPath + pathIndex + "bg.png");  
						//yushu.skin = unitPath + pathIndex + "bg.png";
						yushu.scale(1, 0.25, true); 
						yushu.pivotY =Height/2;
						yushu.pos(j,0);
						img.addChild(yushu); 
						 
					 }
					 
				 }  
				 for (var i:int = 0; i < num; i++ )
				 {
					var u:Image = new Image();
					u.loadImage(unitPath + pathIndex + ".png");  
					//u.skin = unitPath + pathIndex + ".png";
					u.scale(0.25,0.25,true);
					u.pivotX = unitwidth / 2; u.pivotY = Height / 2;
					u.pos(i*unitwidth+yu/2+4,0);
					img.addChild(u);
					trace(unitPath + pathIndex + ".png");
				 } 
				  
			 } 
			  
			  img.pivotX = _width / 2;
			  
		}
		 
		public function GetSide(xL:Number,widthL:Number):CutResult
		{ 
			var cutResul:CutResult = new CutResult(); 
			var xb:Number = img.x-width/2;
			var wb:Number = width;
			if (xb + wb < xL||xL+widthL<xb)
			{
					cutResul.DropBlock.x = xb;
					cutResul.DropBlock.y = wb;
					if (xb + wb < xL) CutForward =-1;
					if (xL+widthL<xb) CutForward =1;
					cutResul.DropBlock.z = CutForward;
					 
			}else 
			{
				 
				var xCut:Number = 0; var wCut:Number = 0; var CutForward:Number = 0;
				if (xb > xL)
				{
						if (xb+wb-(xL + widthL)<= widthL * 0.05)
						 {
							 ///误差小于5% 算完美搭建
							 xb = xL; 
						 } 
						 xCut = xL + widthL;
						 wCut = xb+wb-(xL + widthL);
						 CutForward = 1; 
						cutResul.NextBlock.x = xb;
						cutResul.NextBlock.y = xCut - xb;
						cutResul.NextBlock.z = CutForward;
						
				}else 
				{
						if (xL - xb <= widthL * 0.05)
						 {
							 ///误差小于5% 算完美搭建
							 xb = xL; 
						 } 
						 xCut = xb;
						 wCut = xL - xb; 
						 CutForward = -1; 
						cutResul.NextBlock.x = xL;
						cutResul.NextBlock.y = xb + width - xL;
						cutResul.NextBlock.z = CutForward;
				}
					cutResul.DropBlock.x = xCut;
					cutResul.DropBlock.y = wCut;
					cutResul.DropBlock.z = CutForward;
					cutResul.pathIndex = pathIndex;
				 
			}
			 return cutResul;
		}
		 public function ClearBlock():void
        {
			 if (this.img.parent != null)
			 {
				 this.img.parent.removeChild(this.img);
			 }
			 
        }
		 public function get Height():Number{
			return heights[pathIndex-1]/4; 
			 
		}
		///受重力影响时的动作
		public function Gravity(bot:Number):void
		{ 
			 v += g;
			 img.y += v;   
			 var t:Number=(bot - img.y) / hoffset;
			 img.filters = [AlphaFilter(t)];
			 if (LR > 0)
			 { 
				img.rotation = ExQuaternion.Lerp(0, 180, 1 - t); 
			 } 
			 else { 
				img.rotation = ExQuaternion.Lerp(360, 180, 1 - t); 
			 } 
			 if (img.y > bot)
			 {
				 if (img.parent != null)
				 {
					 img.parent.removeChild(img);
					 
				 }
				 
			 }
		}
		
		private function AlphaFilter(t:Number):ColorFilter
		{
			//由 20 个项目（排列成 4 x 5 矩阵）组成的数组，透明图
			var alphascaleMat:Array = [
				1, 0, 0, 0, 0, 
				0, 1, 0, 0, 0, 
				0, 0, 1, 0, 0, 
				0, 0, 0, t, 0];
			
			//创建一个颜色滤镜对象，透明图
			var alphascaleFilter: ColorFilter = new ColorFilter(alphascaleMat);
			return alphascaleFilter; 
		} 
		
		public function VOffset(bot:Number):void
		{
			hoffset = bot - img.y;
		}
		
	}

}