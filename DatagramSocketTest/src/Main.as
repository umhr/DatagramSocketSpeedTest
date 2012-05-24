package 
{
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class Main extends Sprite 
	{
		private var _numericStepper:NumericStepper;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(new DatagramSocketTest());
			setFPSStepper();
		}
		
		private function setFPSStepper():void 
		{
			new Label(this, 250, 415, "FPS:");
			_numericStepper = new NumericStepper(this, 280, 415, onNumericStepper);
			_numericStepper.minimum = 1;
			_numericStepper.maximum = 120;
			_numericStepper.value = stage.frameRate;
		}
		
		private function onNumericStepper(event:Event):void 
		{
			stage.frameRate = _numericStepper.value;
		}
	}
	
}