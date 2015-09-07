package src.view;

import js.JQuery;
import jp.saken.utils.Dom;
import jp.saken.utils.Handy;
import src.datalist.Clientlist;
import src.datalist.Worklist;
import src.datalist.Teamlist;
import src.datalist.Memberlist;

class Form {
	
	private static var _jParent:JQuery;
	private static var _jInputs:JQuery;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jParent = new JQuery('#form');
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
		
		if (jTarget.hasClass('client')) Worklist.select(Clientlist.getID(value));
		if (jTarget.hasClass('team')) Memberlist.select(Teamlist.getTeam(value));
		if (jTarget.hasClass('fromtime')) _jInputs.filter('.totime').prop('min',value);
		
	}
	
	/* =======================================================================
	Submit
	========================================================================== */
	private static function submit(event:JqEvent):Void {
		
		var clientID:Int    = Clientlist.getID(_jInputs.filter('.client').prop('value'));
		var workID  :Int    = Worklist.getID(_jInputs.filter('.work').prop('value'));
		var team    :String = Teamlist.getTeam(_jInputs.filter('.team').prop('value'));
		var memberID:Int    = Memberlist.getID(_jInputs.filter('.member').prop('value'));
		var fromtime:String = _jInputs.filter('.fromtime').prop('value');
		var totime  :String = _jInputs.filter('.totime').prop('value');
		
		Result.show(clientID,workID,team,memberID,fromtime,totime);
		
		return untyped false;
		
	}

}