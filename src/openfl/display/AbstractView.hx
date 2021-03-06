package openfl.display;


import lime.graphics.cairo.Cairo;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.events.RenderEvent;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

@:access(openfl.events.Event)
@:access(openfl.geom.ColorTransform)


class AbstractView extends DisplayObject {
	
	
	private var __domCleared:Bool;
	private var __renderEvent:RenderEvent;
	
	
	public function new () {
		
		super ();
		
		__domCleared = true;
		__renderEvent = new RenderEvent (null);
		
	}
	
	
	public function invalidate ():Void {
		
		__setRenderDirty ();
		
	}
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderCairo (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		
		__renderEvent.type = RenderEvent.RENDER_CAIRO;
		__renderEvent.allowSmoothing = renderSession.allowSmoothing;
		__renderEvent.cairo = renderSession.cairo;
		__renderEvent.renderTransform.copyFrom (__renderTransform);
		__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
		__renderEvent.worldTransform.copyFrom (__worldTransform);
		__renderEvent.__renderSession = renderSession;
		
		dispatchEvent (__renderEvent);
		
		renderSession.maskManager.popObject (this);
		__renderEvent.cairo = null;
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderCanvas (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		
		__renderEvent.type = RenderEvent.RENDER_CANVAS;
		__renderEvent.allowSmoothing = renderSession.allowSmoothing;
		__renderEvent.context = renderSession.context;
		__renderEvent.renderTransform.copyFrom (__renderTransform);
		__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
		__renderEvent.worldTransform.copyFrom (__worldTransform);
		__renderEvent.__renderSession = renderSession;
		
		dispatchEvent (__renderEvent);
		
		renderSession.maskManager.popObject (this);
		__renderEvent.context = null;
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		if (stage != null && __worldVisible && __renderable) {
			
			super.__renderDOM (renderSession);
			
			renderSession.blendModeManager.setBlendMode (__worldBlendMode);
			renderSession.maskManager.pushObject (this);
			
			__renderEvent.type = RenderEvent.RENDER_DOM;
			__renderEvent.allowSmoothing = renderSession.allowSmoothing;
			__renderEvent.element = renderSession.element;
			__renderEvent.renderTransform.copyFrom (__renderTransform);
			__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
			__renderEvent.worldTransform.copyFrom (__worldTransform);
			__renderEvent.__renderSession = renderSession;
			
			dispatchEvent (__renderEvent);
			
			renderSession.maskManager.popObject (this);
			__renderEvent.element = null;
			__domCleared = false;
			
		} else if (!__domCleared) {
			
			__renderEvent.type = RenderEvent.CLEAR_DOM;
			__renderEvent.allowSmoothing = renderSession.allowSmoothing;
			__renderEvent.element = renderSession.element;
			__renderEvent.renderTransform.copyFrom (__renderTransform);
			__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
			__renderEvent.worldTransform.copyFrom (__worldTransform);
			__renderEvent.__renderSession = renderSession;
			
			dispatchEvent (__renderEvent);
			
			__renderEvent.element = null;
			__domCleared = true;
			
		}
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderGL (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		renderSession.shaderManager.setShader (null);
		
		__renderEvent.type = RenderEvent.RENDER_OPENGL;
		__renderEvent.allowSmoothing = renderSession.allowSmoothing;
		__renderEvent.gl = renderSession.gl;
		__renderEvent.renderTransform.copyFrom (__renderTransform);
		__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
		__renderEvent.worldTransform.copyFrom (__worldTransform);
		__renderEvent.__renderSession = renderSession;
		
		dispatchEvent (__renderEvent);
		
		renderSession.maskManager.popObject (this);
		__renderEvent.gl = null;
		
	}
	
	
}