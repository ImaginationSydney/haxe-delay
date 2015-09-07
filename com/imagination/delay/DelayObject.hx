/*The MIT License (MIT)

Copyright (c) 2015 P.J.Shand

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

package com.imagination.delay;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */

class DelayObject
{
	public var callback:Dynamic;
	private var params:Array<Dynamic>;
	private var clearObject:Dynamic;
	
	private var frameCount:Int = 0;
	private var frames:Int;
	private var timer:Timer;
	
	public function new():Void
	{
		
	}
	
	public function nextFrame(clearObject:Dynamic, callback:Dynamic, params:Array<Dynamic>=null):Void 
	{
		by(1, clearObject, callback, params);
	}
	
	public function by(frames:Int, clearObject:Dynamic, callback:Dynamic, params:Array<Dynamic>=null):Void 
	{
		this.frames = frames;
		this.clearObject = clearObject;
		this.params = params;
		this.callback = callback;
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
		Update(null);
	}
	
	public function byTime(time:Float, clearObject:Dynamic, callback:Dynamic, params:Array<Dynamic>, units:Int = 1):Void 
	{
		this.clearObject = clearObject;
		this.params = params;
		this.callback = callback;
		
		if (units >= 1) time *= 1000;
		if (units >= 2) time *= 60;
		if (units >= 3) time *= 60;
		if (units >= 4) time *= 24;
		
		timer = new Timer(time, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
		timer.start();
	}
	
	private function OnTimerComplete(e:TimerEvent):Void 
	{
		if (callback != null) {
			fireCallback(callback, params);
		}
		if (clearObject != null) clearObject(this);
		dispose();
	}
	
	private function Update(e:Event):Void 
	{
		if (frames == frameCount) {
			if (callback != null) {
				fireCallback(callback, params);
			}
			if (clearObject != null) clearObject(this);
			dispose();
			return;
		}
		frameCount++;
	}
	
	private function fireCallback(callback:Dynamic, params:Array<Dynamic>=null) 
	{
		if (params == null) {
			callback();
			return;
		}
		switch (params.length) 
		{
			case 0 :
				callback();
			case 1 :
				callback(params[0]);
			case 2 :
				callback(params[0], params[1]);
			case 3 :
				callback(params[0], params[1], params[2]);
			case 4 :
				callback(params[0], params[1], params[2], params[3]);
			case 5 :
				callback(params[0], params[1], params[2], params[3], params[4]);
			case 6 :
				callback(params[0], params[1], params[2], params[3], params[4], params[5]);
			case 7 :
				callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
			case 8 :
				callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
			case 9 :
				callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
			case 10 :
				callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);
			default:
		}
	}
	
	public function dispose():Void
	{
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, Update);
		if (timer != null) {
			timer.stop();
			timer = null;
		}
		callback = null;
		params = null;
		clearObject = null;
	}
}