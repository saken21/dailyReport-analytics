package src.view;

import js.JQuery;
import jp.saken.utils.Dom;
import jp.saken.utils.Handy;
import src.db.Clients;
import src.db.Works;
import src.datalist.Worklist;

class Form {
	
	private static var _jParent:JQuery;
	private static var _jInputs:JQuery;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jParent = new JQuery('#form').addClass('onReady');
		_jInputs = _jParent.find('input');
		
		var now:String = Handy.getPastDate(Date.now().toString(),0);
		_jInputs.filter('.time').prop('max',now).filter('.totime').prop('value',now);
		
		_jInputs.on('change',onChange);
		_jParent.find('.submit').on('click',submit);
		
	}
	
		/* =======================================================================
		Public - Set Input
		========================================================================== */
		public static function setInput(cls:String,value:String = ''):Void {

			_jInputs.filter('.' + cls).prop('value',value);

		}
	
	/* =======================================================================
	On Change
	========================================================================== */
	private static function onChange(event:JqEvent):Void {
		
		var jTarget:JQuery = new JQuery(event.target);
		var value  :String = jTarget.prop('value');
		
		if (jTarget.hasClass('client')) Worklist.select(Clients.getID(value));
		if (jTarget.hasClass('fromtime')) _jInputs.filter('.totime').prop('min',value);
		
	}
	
	/* =======================================================================
	Submit
	========================================================================== */
	private static function submit(event:JqEvent):Void {
		
		if (!_jParent.hasClass('onReady')) return untyped false;
		
		var clientID:Int    = Clients.getID(_jInputs.filter('.client').prop('value'));
		var workID  :Int    = Works.getID(_jInputs.filter('.work').prop('value'));
		var fromtime:String = _jInputs.filter('.fromtime').prop('value');
		var totime  :String = _jInputs.filter('.totime').prop('value');
		
		Result.show(clientID,workID,fromtime,totime);
		
		return untyped false;
		
	}

}