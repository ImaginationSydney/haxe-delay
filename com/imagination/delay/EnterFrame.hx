package com.imagination.delay;

import haxe.Timer;
import lime.app.Application;
/**
 * ...
 * @author P.J.Shand
 */
class EnterFrame
{
	private static var enterFrameObjects = new Array<EnterFrameObject>();
	private static var _started:Bool = false;
	private static var started(get, set):Bool;
	
	public function new() 
	{
		
	}
	
	private static function OnTick():Void
	{
		if (!started) return;
		if (enterFrameObjects.length == 0) started = false;
		for (i in 0...enterFrameObjects.length) 
		{
			enterFrameObjects[i].tick();
		}
		Timer.delay(OnTick, Std.int(1000 / Application.current.frameRate));
	}
	
	static public function add(callback:Int->Void):Void 
	{
		started = true;
		var enterFrameObject:EnterFrameObject = new EnterFrameObject(callback);
		enterFrameObject.start();
		enterFrameObjects.push(enterFrameObject);
	}
	
	static public function remove(callback:Int->Void):Void 
	{
		for (i in 0...enterFrameObjects.length) 
		{
			if (enterFrameObjects[i].callback == callback) {
				enterFrameObjects[i].stop();
				enterFrameObjects[i] = null;
				enterFrameObjects.splice(i, 1);
			}
		}
	}
	
	
	private static function get_started():Bool
	{
		return _started;
	}
	
	private static function set_started(value:Bool):Bool
	{
		if (_started == value) return value;
		_started = value;
		if (_started) OnTick();
		return _started;
	}
}