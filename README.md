# haxe-delay

Delay callback function until the next frame.

<pre>Delay.nextFrame(Callback);
 
private function Callback():void 
{
	
}
</pre>
Delay callback function until the next frame and pass parameters.

<pre>Delay.nextFrame(Callback, [1, "test"]);
 
private function Callback(value:int, str:String):void 
{
	
}</pre>
Delay callback function by X number of frames and pass parameters.

<pre>Delay.byFrames(5, Callback, [1, "test"]);
 
private function Callback(value:int, str:String):void 
{
	
}</pre>
Delay callback function by X amount of time pass parameters.

<pre>Delay.byTime(2, Callback, [1, "test"], Delay.TIME_UNIT_SECONDS);
 
private function Callback(value:int, str:String):void 
{
	
}</pre>
Available time units are as follows:
<pre>Delay.TIME_UNIT_MILLISECONDS
Delay.TIME_UNIT_SECONDS
Delay.TIME_UNIT_MINUTES
Delay.TIME_UNIT_HOURS
Delay.TIME_UNIT_DAYS</pre>
