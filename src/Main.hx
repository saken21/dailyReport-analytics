/**
* ================================================================================
*
* Daily Report Analytics ver 1.00.04
*
* Author : KENTA SAKATA
* Since  : 2015/09/01
* Update : 2015/10/02
*
* Licensed under the MIT License
* Copyright (c) Kenta Sakata
* http://saken.jp/
*
* ================================================================================
*
**/
package src;

import js.JQuery;

class Main {
	
	public static function main():Void {
		
		new JQuery('document').ready(Manager.init);
		
	}

}