package com.angrycutlet.drawingstuff.view
{
	import com.angrycutlet.drawingstuff.view.graphics.DSBaseGraphics;
	
	import flash.geom.Point;
	
	public class DSRectangle extends DSBaseGraphics
	{
		private var clickCount:int = 0;
		private var isSelected:Boolean = false;
		
		private var _pointOne:Point;
		private var _pointTwo:Point;
		
		public function DSRectangle()
		{
			super();
		}
		
		public function drawPoint(point:Point):void 
		{
			clickCount++;
			if ( clickCount == 1 ) 
			{
				this.graphics.beginFill( 0x00FF00, 0.25 );
				_pointOne = point;
			}
			if ( clickCount == 2 ) 
			{
				_pointTwo = point;
				this.graphics.drawRect( _pointOne.x, _pointOne.y, _pointTwo.x - _pointOne.x, _pointTwo.y - _pointOne.y );
				this.graphics.endFill();
			}
		}
		
	}
}