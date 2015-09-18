package com.imagination.delay;

import haxe.Timer;
import lime.app.Application;

/**
 * ...
 * @author P.J.Shand
 */
class EnterFrameObject
{
	public var callback:Int->Void;
	public var running:Bool = false;
	
	public function new(callback:Int->Void) 
	{
		this.callback = callback;
	}
	
	public function start():Void
	{
		running = true;
		OnTick();
	}
	
	public function stop():Void
	{
		running = false;
	}
	
	private function OnTick() 
	{
		if (!running) return;
		callback(0);
		Timer.delay(OnTick, Std.int(1000 / Application.current.frameRate));
	}
}