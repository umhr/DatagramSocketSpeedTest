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
			var numericStepper:NumericStepper = new NumericStepper(this, 280, 415, onNumericStepper);
			numericStepper.minimum = 1;
			numericStepper.maximum = 120;
			numericStepper.value = stage.frameRate;
		}
		
		private function onNumericStepper(event:Event):void 
		{
			stage.frameRate = event.target.value;
		}
	}
	
}