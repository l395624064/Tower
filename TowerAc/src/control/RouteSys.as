package control 
{
	import laya.d3.math.Vector3;
	public class RouteSys 
	{
		
		public function RouteSys() 
		{ 
			 
		}
		public var temproute:Vector.<Vector3>;
		public var route:Vector.<Vector3>;
		public var overPoint:Vector3;
        private static var  _instance:RouteSys;  
		 
 
		public static function get Instance():RouteSys 
		{
			if(_instance==null)
			{ 
			  _instance=new RouteSys();
			} 
			return _instance; 
		} 

		 public function Init():void{
			 
			 temproute=new Vector.<Vector3>(); 
			 route = new Vector.<Vector3>();  
			 overPoint = Vector3.ZERO;
			 
		}
		
		 public function Start():void{
			  temproute.push(new Vector3(140, 1128, 0));
			  for (var i:int = 0; i < temproute.length; i++)
			 {
				 route.push(temproute[i]);
			 }
		}
		
		public function SetRoute(point:Vector3):void
        { 
			route.push(point); 
           
		}
		public function StartClimb():void
        { 
			route.push(new Vector3(Laya.stage.width / 2, 1120, 0)); 
           
		}
		
		public function OverPoint():void
        { 
			overPoint = route[route.length-1];
           
		}
	}

}