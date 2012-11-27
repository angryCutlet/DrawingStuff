package com.angrycutlet.drawingstuff.view.graphics
{
	import flash.geom.Point;
	
	import spark.core.SpriteVisualElement;
	
	public class DSBaseGraphics extends SpriteVisualElement
	{
		private var _startPoint:Point = new Point();
		
		public function DSBaseGraphics()
		{
			super();
		}

		public function get startPoint():Point
		{
			return _startPoint;
		}

		public function set startPoint(value:Point):void
		{
			_startPoint = value;
		}

	}
}