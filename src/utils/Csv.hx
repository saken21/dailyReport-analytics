package src.utils;

import haxe.Http;
import js.JQuery;
import jp.saken.utils.Handy;
import jp.saken.utils.Dom;

class Csv {
	
	private static var _jParent:JQuery;
	
	private static inline var PHP_URL   :String = 'files/php/exportCSV.php';
	private static inline var DELETE_URL:String = 'files/php/deleteCSV.php';
	private static inline var FILE_NAME :String = 'data.csv';
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jParent = new JQuery('#csv');
		
		Dom.jWindow.on('beforeunload',deleteCSV);
		deleteCSV();
		
	}
	
		/* =======================================================================
		Public - Export
		========================================================================== */
		public static function export(data:Array<Dynamic>):Void {

			http(getAdjusted(data).join('\n'));

		}
	
	/* =======================================================================
	Get Adjusted
	========================================================================== */
	private static function getAdjusted(data:Array<Dynamic>):Array<String> {
		
		var array:Array<String> = [];
		
		for (p in 0...data.length) {
			array.push(data[p].join(','));
		}
		
		return array;
		
	}
	
	/* =======================================================================
	Http
	========================================================================== */
	private static function http(data:String):Void {
		
		var http:Http = new Http(PHP_URL);
		
		http.onData = onExported;
		
		http.setParameter('data',data);
		http.setParameter('filename',FILE_NAME);
		
		http.request(true);
		
	}
	
	/* =======================================================================
	On Exported
	========================================================================== */
	private static function onExported(result:String):Void {
		
		var jAnchor :JQuery = new JQuery('<a>');
		
		jAnchor.prop('download',FILE_NAME);
		jAnchor.prop('href','files/php/csv/' + FILE_NAME);
		jAnchor.prop('target','_blank');
		
		jAnchor.addClass('download').text('→ Download ' + FILE_NAME);
		_jParent.html(jAnchor);
		
		Dom.window.alert('CSVの書き出しが完了しました。');
		
	}
	
	/* =======================================================================
	Delete CSV
	========================================================================== */
	private static function deleteCSV(event:JqEvent = null):Void {
		
		new Http(DELETE_URL).request(true);
		
	}
	
}