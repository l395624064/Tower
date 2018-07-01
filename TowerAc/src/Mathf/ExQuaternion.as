package Mathf 
{
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	/**
	 * ...
	 * @author ...
	 */
	public class ExQuaternion 
	{
		var vector1:Vector3 = Vector3.ZERO; 
			var vector2:Vector3 = Vector3.ZERO; 
			var vector3:Vector3 = Vector3.ZERO; 
		
		public function ExQuaternion() 
		{
			
		}
		 
		static public function Lerp(a:Number,b:Number,t:Number):Number
        {
			if (b == a) return a;
			return a+ t * (b - a);
		}
	}

}