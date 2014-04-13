 /**
	 @license
	 Copyright @ 2012 Alessandro Zifiglio
	 http://www.typps.com
 */
(function(window, document){
	if (!String.prototype.trim) {
	  String.prototype.trim = function () {
		return String(this).replace(/^\s+/, '').replace(/\s+$/, '');
	  };
	}
	/**
		@function Augments the function object with an exports method that facilitates exposing a method out of it's contained scope to the outside.
		@description Exports the symbol out of it's contained scope and exposes it to the outside by attaching it to the window object.
		@param {string|Object} fullName The full name of the class to export outside the private context it is in.
		@param {Object=} obj The object to export. If not supplied, nothing is going to happen which is useful when wanting to trick google closure compiler from removing dead code. 
	*/
	Function.extern = function (fullName, obj) {
		var parts, current, length, i, container = window;
		if(!fullName || !obj)return;
		parts = fullName.split('.');
		length  = parts.length;
		for(i = 0; i < length; i++) {
			current = parts[i];
			if (i === (length - 1)) {
				container[current] = obj;
			}
			else if(container[current]) {
				container = container[current];
			}
			else {
				container = container[current] = {};
			}
		}
		return this;
	}
	var extern = Function.extern;
	
	/**
		@name Small
		@namespace
		@class
		@constructor
		@description Small is a tiny js library (3.86kb without gzip compression) that provides you with only the absolute necessary boiler plate code 
		you'll end up writing when not using a heavy js library. 
		Note: this is a much smaller version of $mall, my js utility lib which I never gotten around to releasing to the public yet.
		This version contains only what we need with the path menu.
	*/
	var Small = Small || function(){};
	extern('Small', Small);
	
	/**
		@ignore
		@private
		@enum
		@description Used in congugation with addEvent and removeEvent.
	*/
	Small.Behavior = {
		add: 0,
		remove: 1
	};
	extern(Small.Behavior);
	
	/**
	@ignore
	@private
	@function
	@description An augmentation of the internal console.log method that is enviornmental debug flag aware. 
	Just set a public variable $mDEBUG to true when you want console.log output.
	@param {string|Object|Array} args
*/
	Small.prototype.log = function(args) {
		var c =  window['console'], flag = window['$m_DEBUG'] || false;
		if (flag) {
			if(!c) { 
				c = window['console'] = {};
			}
			if(!c.log || !c.log.apply){
				c['log'] = function() { };
			}
			c.log.apply(c, arguments);
		}
	};
	extern(Small.log);
	
	/**
		@private
		@ignore
		@function
		@description Provides cross browser event handling. This should work well upto ie7 and all modern browsers/devices
		@param {number} behavior A value indicating whether to add or remove the event handler. Use Small.Behavior enum or pass a value of 0/1.
		@param {Element} element The element on which to add/remove the event.
		@param {string} types The type of event to register without the 'on' prefix. Separate by space when wanting to register mutiple events with the same handler eg : 'click touchstart'.
		@param {function()} handler The callback function to invoke when the event is executed or the handler to remove in case we are removing.
		@param {boolean=} useCapture Specifies whether the EventListener being added or removed was registered as a capturing listener or not. 
		If a listener was registered twice, one with capture and one without, each must be removed separately. 
		Removal of a capturing listener does not affect a non-capturing version of the same listener, and vice vers
	*/
	Small.prototype.handleEvent = function(behavior, element, types, handler, useCapture){
		var all, ie, i, type;
		if (!element || !types || !handler) {
			return;
		}
		if(behavior === 0/*Small.Behavior.add*/){
			all = 'add';
			ie = 'attach';
		}
		else{
			all = 'remove';
			ie = 'detach';
		}
		useCapture = useCapture || false;
		types = types.split(' ');
		for(i in types){
			type = types[i];
			if (element[all + 'EventListener']) {
				element[all + 'EventListener'] (type, handler, useCapture);
			} else if (element[ie+'Event']) {
				element[ie+'Event'] ('on'+type, handler);
			} else {
				element['on'+type] = behavior === 1/*Small.Behavior.remove*/ ? null : handler;
			}
		}
	};
	/**
		@event
		@description Binds the specified function to an event, so that the function gets called whenever the event fires on the object.
		@param {Element} element The element on which to add/remove the event.
		@param {string} types The type of event to register without the 'on' prefix. Separate by space when wanting to register mutiple events with the same handler eg : 'click touchstart'.
		@param {function()} handler The callback function to invoke when the event is executed or the handler to remove in case we are removing.
		@param {boolean=} useCapture Specifies whether the EventListener being removed was registered as a capturing listener or not. 
		If a listener was registered twice, one with capture and one without, each must be removed separately. 
		Removal of a capturing listener does not affect a non-capturing version of the same listener, and vice vers
		@example
	var element = $m.find('div1');
	$m.addEvent(element, 'click', function(args){
		console.log('hello world');
	});
		@see #.removeEvent
	*/
	Small.prototype.addEvent = function (element, types, handler, useCapture) {
		this.handleEvent(0/*Small.Behavior.add*/, element, types, handler, useCapture);
	};
	extern(Small.addEvent);
	
	
	/**
		@function
		@description Unbinds the specified function from the event, so that the function stops receiving notifications when the event fires.
		@param {Element} element The element on which to add/remove the event.
		@param {string} types The type of event to register without the 'on' prefix. Separate by space when wanting to register mutiple events with the same handler eg : 'click touchstart'.
		@param {function()} handler The callback function to invoke when the event is executed or the handler to remove in case we are removing.
		@param {boolean=} useCapture Specifies whether the EventListener being removed was registered as a capturing listener or not. 
		If a listener was registered twice, one with capture and one without, each must be removed separately. 
		Removal of a capturing listener does not affect a non-capturing version of the same listener, and vice vers
		@see #.addEvent
		@example
	var element = $m.find('div1');

	this.clickDelegate = $m.createDelegate(this, clickHandler);
	$m.addEvent(element, 'click', this.clickDelegate);

	function clickHandler(args){
		console.log('hello world');
	}

	//since we now have a pointer to the function attached in this.clickDelegate, 
	//we can easily detach it when required 
	//and dispose of it with elegance eg:
	$m.removeEvent(element, 'click',this.clickDelegate);
	*/
	Small.prototype.removeEvent = function (element, types, handler, useCapture) {
		this.handleEvent(1/*Small.Behavior.remove*/, element, types, handler, useCapture);
	};
	extern(Small.removeEvent);
	
	/**
	@function
	@description Returns the name part of the object literal when given the value eg: {name : value}
	@param {Object} enumType The type of the enum to convert to.
	@param {number} value The value part of the object literal whose name you want.
	@example 
	var Fruits = {apple:0, banana:1, grape:3};
	var selectedFruit = Fruits.banana;
	var name = this.parseEnum(Fruits, selectedFruit);//returns banana
	*/
	Small.prototype.parseEnum = function (enumType, value) {
		var i = 0, name;
		for (name in enumType) {
			if (enumType.hasOwnProperty(name)) {
				if (i === value) {
					return name;
				}
				i++;
			}
		}
		return null;
	};
	extern(Small.parseEnum);
	
	/**
	@function
	@param {Array.<Object>} filter A list of dimentions we want to test for. 
	@param {number} filter.minWidth The min-width we want to test for. If not provided then max-width is accounted for. If both are not provided then a value of false is returned.
	@param {number} filter.maxWidth The max-width we want to test for. If not provided then min-width is accounted for. If both are not provided then a value of false is returned.
	@param {boolean} [filter.byDevice=false] Specifies whether we want to test against the device width or just the width of the viewport. This is false by default.
	@return {boolean} A value of true indicates that we currently meet the mediaQuery filter.
	*/
	Small.prototype.mediaQuery = function(filter, byDevice){
		byDevice = (typeof(byDevice) === 'boolean') ? byDevice : false;
		if(! filter || filter.length === 0) {
			//we have no filter, so we're good.
			return true;
		}
		var width =  (byDevice ? window.screen.width : document.documentElement.clientWidth),
		i, l, size, minWidth, maxWidth, number = 'number', test;
		for(i = 0, l = filter.length;i < l; i++){
			minWidth = filter[i]['minWidth'];
			maxWidth = filter[i]['maxWidth'];
			test = false;
			if(typeof(minWidth) === number){
				if(width >= minWidth){
					test = true;
				}
			}
			if(typeof(maxWidth) === number){
				test = false;
				if(width <= maxWidth){
					test = true;
				}
			}
			if (test){
				return test;
			}
		}
		return false;
	};
	extern(Small.mediaQuery);
	
	/** 
	@function Replaces each format item in a String object with the text equivalent of a corresponding object's value.
	@returns A copy of the string with the formatting applied.
	@description <p>Use the format function to replace specified format items with the text representation of the corresponding object values. The args argument can contain a single object or an array of objects. The format argument contains zero or more runs of fixed text intermixed with one or more format items. Each format item corresponds to an object in objects. At run time, each format item is replaced by the string representation of the corresponding object in the list.</p>
	<p>Format items consist of a number enclosed in braces, such as {0}, that identifies a corresponding item in the objects list. Numbering starts with zero. To specify a single literal brace character in format, specify two leading or trailing brace characters; that is, "{{" or "}}". Nested braces are not supported.</p>
		@example var result = $m.formatString('Hello {0}', 'world');
	*/
	Small.prototype.formatString = function () {
		var s = arguments[0], i, reg;
		for (i = 0; i < arguments.length - 1; i++) {
			reg = new RegExp("\\{" + i + "\\}", "gm");
			s = s.replace(reg, arguments[i + 1]);
		}

		return s;
	};
	extern(Small.formatString);

	/**
		@function Creates a callback method that retains the context first used during an objects creation.
		@description <p>Use the createDelegate function when setting up an event handler to point to an object method. The createDelegate function is useful when setting up an event handler to point to an object method that must use the this pointer within its scope.</p><p>The createDelegate function can also be used with a null instance.</p>
		@param {Object} instance The object instance that will be the context for the function.
		@param {function()} method The function from which the delegate is created.
		@returns {function()} A delegate function.
		@example var delegate = $m.createDelegate(instance,method);
	*/
	Small.prototype.createDelegate = function (instance, method) {
		return function () {
			return method.apply(instance, arguments);
		};
	};
	extern(Small.createDelegate);
	
	
	/**
	@function
	@description Gets the x/y positions of the element based on the parents position. 
	This is useful when we want to absolutely position the element within the bounds of the parent, where the parent 
	could likely not be absolutely positioned in turn.
	@param {Element} elem The element whose positoin we want to determine based on the parent.
	*/
	Small.prototype.getXY = function (elem) {
		var pos = { x: 0, y: 0 }, offsetParent;
		do {
			pos.x += elem.offsetLeft;
			pos.y += elem.offsetTop;
		} while (elem = elem.offsetParent);
		return pos;
	};
	extern(Small.getXY);
	
	/**
		@function
		@description Adds a CSS class to the HTML Document Object Model (DOM) element passed as the first parameter. This method is also tolerant to elements with multiple class names separated by space.
		@param {Element} element The DOM element onto which the css class is attached.
		@param {string} className The css class name to attach on the DOM element
		@example
		var element = $m.find('element1');
		this.addCssClass(element, className);
	*/
	Small.prototype.addCssClass = function (element, className) {
		if (!element || !className || (element.className && element.className.search(new RegExp('\\b' + className + '\\b')) !== -1)) {
			return;
		}
		element.className += (element.className ? ' ' : '') + className;
	};
	extern(Small.addCssClass);

	/**
		@function
		@description Removes a CSS class to the HTML Document Object Model (DOM) elementent passed as the first parameter. This method is also tolerant to elementents with multiple class names separated by space.
		@param {Element} element The DOM elementent on which the css class needs to be removed.
		@param {string} className The css class name to remove from the DOM elementent
		@example
		var element = $m.find('element1');
		this.removeCssClass(element, className);
	*/
	Small.prototype.removeCssClass = function (element, className) {
		if (!element || !className || (element.className && element.className.search(new RegExp('\\b' + className + '\\b')) === -1)) {
			return;
		}
		element.className = element.className.replace(new RegExp('\\s*\\b' + className + '\\b', 'g'), '');
	};
	extern(Small.removeCssClass);
	
	/**
		@function
		@description Determines whether an element contains a css class name.
		@param {Element} element The DOM elementent on which to test the presence of a class name.
		@param {string} className The css class name to check.
		@returns {boolean} A value of true or false that reflects the outcome of this operation.
		@example
		var element = $m.find('element1');
		if($m.containsCssClass(element, 'someclass')){
			console.log('class name found');
		}
	*/
	Small.prototype.containsCssClass = function (element, className){
		if(!element || !className)return false;
		/**@type {boolean}*/
		return (element.className && element.className.search(new RegExp('\\b' + className + '\\b')) !== -1);
	};
	extern(Small.containsCssClass);
	
	/**
		@function
		@description Sets the cssText on an element. This is quite useful when not wanting to set css properties individually on an element. When there is more than one property 
		that affects layout, a reflow of the document occurs. By setting the css for multiple css properties at once through this method you can avoid this taxation.
		@param {Element} elem The html element whose cssText you want to set.
		@param {string} cssText The cssText you want to set on the element.
		@param {Array.<string>} styles A list of css properties to preserve before apply the csstext.
		@example 
var elem = $m.find('myelement');
if(elem){
	$m.setCssText(elem, 'width:200px;height:300px;display:block');
}
	*/
	Small.prototype.setCssText = function(elem, cssText, styles){
		var i, preserve = [], key, value, cssPreserved = '';
		if(typeof(styles) !== 'undefined'){
			for(i in styles){
				key = styles[i];
				value = elem.style[key];
				if(value && value['trim']().length > 0){
					preserve.push(this.formatString('{0}:{1}', key, value)); 
				}
			}
		}
		if (preserve.length > 0){
			cssPreserved = preserve.join(';');
		}
		if(typeof(elem.style.cssText) !== 'undefined') {
			/**@type {string}*/
			elem.style.cssText = cssText + cssPreserved;
		} else{
				/** @type {string}*/
			  elem.setAttribute('style', cssText + cssPreserved);
		}
	};
	extern(Small.setCssText);
	
	/**
		@function
		@description Gets the view port ( the currently viewable area on screen ) as an associative array {width: xx, height: xx}
		@param {string} propertyName The property name. This is inner by default and will retrieve the innerWidth/innerHeight values. 
		A value of outer on the other hand will return the outer width/height.
	*/
	Small.prototype.getViewport = function(propertyName){
		var e = window;
		propertyName || (propertyName = 'inner');
		if ( !( 'innerWidth' in window ) )
		{
			propertyName = 'client';
			e = document.documentElement || document.body;
		}
		return { 'width' : e[ propertyName + 'Width' ] , 'height' : e[ propertyName + 'Height' ] };
	};
	extern(Small.getViewport);
	
	/**
		@function
		@description Gets the scroll position of the window as an associative array {x: xx, y: xx}
	*/
	Small.prototype.getScrollPos = function(){
		var x, y, documentElement = document.documentElement, body = document.body;
		if (self.pageYOffset) {
			y = self.pageYOffset;
			x = self.pageXOffset;
		} else if (documentElement && documentElement.scrollTop) {
			y = documentElement.scrollTop;
			x = documentElement.scrollLeft;
		} else if (body) {
			y = body.scrollTop;
			x = body.scrollLeft;
		}
		return {'x': x, 'y': y};
	};
	extern(Small.getScrollPos);
	
	extern('$m', new Small());
}(window, document));
 (function(window, document, $){
	 var extern = Function.extern, PathMenu = window['PathMenu'] || 
	/**
			@name PathMenu
			@namespace
			@class
			@constructor
			@description A Reinvention of the Path menu in javascript/css3
			@param {Object=} options Startup options
			@param {Element} options.elem The main element that will hold the menu.
			@param {number} [options.zIndex=100000] The z-index order of this element. If one is not supplied a default value of 100000 is used.
			@param {number} [options.paddingLeft=10] The padding of the main button from the left edge of the screen. The menu has to be using an expand pattern of 
			   PathMenu.ExpandPattern.leftBottomFixedArc or PathMenu.ExpandPattern.leftTopFixedArc.
			@param {number} [options.paddingBottom=10] The padding of the main button from the bottom edge of the screen. The menu has to be using an expand pattern of 
			   PathMenu.ExpandPattern.leftBottomFixedArc or PathMenu.ExpandPattern.rightBottomFixedArc.
			@param {number} [options.paddingTop=10] The padding of the main button from the Top edge of the screen. The menu has to be using an expand pattern of 
			   PathMenu.ExpandPattern.leftTopFixedArc or PathMenu.ExpandPattern.rightTopFixedArc.
			@param {number} [options.paddingRight=10] The padding of the main button from the Right edge of the screen. The menu has to be using an expand pattern of 
			   PathMenu.ExpandPattern.rightTopFixedArc or PathMenu.ExpandPattern.rightBottomFixedArc.
			@param {Array.<Object>} options.mediaFilter A  array of literal objects containing minWith and maxWidth keys whose values are numbers. 
				   This allows you to force the component to render based on viewport size of the viewing device.
			@param {Array.<Object>} options.items A string array containing the commands for each menu item or a much richer array of literal objects containing menu item specific options. 
			@param {number} [options.duration=1000] When a button is clicked, this allows you to regulate the default duration before navigation is triggered. 
			This is to allow the animations in the page to complete before the page redirects to the new url.
			@param {function()} [options.onSelectedItem=null] A callback function that is fired when a menu item is selected. 
					   To distinguish a menu item you need to use the command item value passed in the items array property below. 
			@param {function()} [options.onMainButtonClick=null] A callback function that is fired when the main button is clicked.  
			@param {function()} [options.onParentButtonClick=null] A callback function that is fired when a menu item that contains child menu items is clicked. 
			@param {function()} [options.onBackButtonClick=null] A callback function that is fired when the back button is clicked. 
			@param {function()} [options.onItemButtonClick=null] A callback function that is fired when a menu item button is clicked. 
			@param {boolean} [options.enableUrlHash=false] When true, clicking a button will update the url with the command value you set on the menu item.
			@param {number} [options.radius=50] The distance of the menu items from the main menu button's mid point. This value effects the menu when it's inline. 
				The menu is placed inline when using an expandPattern of one of the following:
			   PathMenu.ExpandPattern.circle, PathMenu.ExpandPattern.lineTop, PathMenu.ExpandPattern.lineRight, PathMenu.ExpandPattern.lineBottom, PathMenu.ExpandPattern.lineLeft, PathMenu.ExpandPattern.lineMiddleHorizontal, PathMenu.ExpandPattern.lineMiddleVertical.
			@param {number} [options.expandPattern=0] Controls the positioning of menu items around the main button. The default is a value of 0 which represents the enum value PathMenu.ExpandPattern.leftBottomFixedArc. 
			   <ol start="0">
				   <li>PathMenu.ExpandPattern.circle</li>
				   <li>PathMenu.ExpandPattern.lineTop</li> 
				   <li>PathMenu.ExpandPattern.lineRight</li> 
				   <li>PathMenu.ExpandPattern.lineBottom</li> 
				   <li>PathMenu.ExpandPattern.lineLeft</li> 
				   <li>PathMenu.ExpandPattern.lineMiddleHorizontal</li>
				   <li>PathMenu.ExpandPattern.lineMiddleVertical</li>
				   <li>PathMenu.ExpandPattern.leftBottomFixedArc</li> 
				   <li>PathMenu.ExpandPattern.leftTopFixedArc</li> 
				   <li>PathMenu.ExpandPattern.rightBottomFixedArc</li> 
				   <li>PathMenu.ExpandPattern.rightTopFixedArc</li>
				</ol>
			@param {Object} [options.bezierCurve=null] The control points of a bezier curve {x0, y0, x1, y1, x2, y2, x3}. This allows you  
			to customize the curve fully. eg: {'x0':70, 'y0':45, 'x1':75, 'y1':75, 'x2':75, 'y2':75,'x3':45}. Note: We provide a visual tool that can autogenerate these values
			by simply sliding the desired control points. Look for it in the home directory.
			@param {string} [options.mainButton=null] Sets the url for the main button, back button url, width and height to the background image used on the main button.
			@param {boolean} [options.alwaysExpanded=false] A value of true stops the menu from collapsing when the document is clicked. Default is false.
	*/
	function(options){
		var preset1 = {'x0':70, 'y0':45, 'x1':107, 'y1':75, 'x2':75, 'y2':75,'x3':75},
		preset2 = {'x0':49, 'y0':176, 'x1':91, 'y1':146, 'x2':78, 'y2':100,'x3':70};
		if(options){
			this.elem = options['elem'];
			this.mediaFilter = options['mediaFilter'] || [];
			this.scrollbarThickness = 19;//ie 17 firefox 19, guess we'll just go for 19.
			
			this.items = options['items'] || [];
			
			this.zIndex = options['zIndex'];
			if(typeof(this.zIndex) !== 'number'){
				this.zIndex = 100000;
			}
			this.paddingLeft = options['paddingLeft'];
			if(typeof(this.paddingLeft) !== 'number'){
				this.paddingLeft = 10;
			}
			this.paddingBottom = options['paddingBottom'];
			if(typeof(this.paddingBottom) !== 'number'){
				this.paddingBottom = 10;
			}
			this.paddingTop = options['paddingTop'];
			if(typeof(this.paddingTop) !== 'number'){
				this.paddingTop = 10;
			}
			this.paddingRight = options['paddingRight'];
			if(typeof(this.paddingRight) !== 'number'){
				this.paddingRight = 10;
			}
			this.duration = options['duration'];
			if(typeof(this.duration) !== 'number'){
				this.duration = 1000;
			}
			this.radius = options['radius'];
			if(typeof(this.radius) !== 'number'){
				this.radius = 50;
			}
			this.expanded = options['expanded'] || false;
			this.expandTimeout = options['expandTimeout'];
			if(typeof(this.expandTimeout) !== 'number'){
				this.expandTimeout = 0;
			}
			this.showLabel = options['showLabel'] || false;
			
			this.selectedItemHandler = options['onSelectedItem'] || null;
			this.mainButtonClickHandler = options['onMainButtonClick'] || null;
			this.parentButtonClickHandler = options['onParentButtonClick'] || null;
			this.backButtonClickHandler = options['onBackButtonClick'] || null;
			this.itemButtonClickHandler = options['onItemButtonClick'] || null;

			this.enableUrlHash = options['enableUrlHash'] || false;
			this.expandPattern = options['expandPattern'];
			if(typeof(this.expandPattern) !== 'number'){
				this.expandPattern = 7/*PathMenu.ExpandPattern.leftBottomFixedArc*/;
			}
			this.bezierCurve = options['bezierCurve'] || null; //format must be: {x0:0, y0:0, x1:0, y1:0, x2:0, y2:0,x3:0};
			this.alwaysExpanded = options['alwaysExpanded'] || false;
			this.mainButtonOptions = options['mainButton'] || {};
		}
		
		this.bezierCurvePreset = {
			'leftBottomFixedArc': preset1
			, 'leftTopFixedArc': preset2
			, 'rightBottomFixedArc': preset1
			, 'rightTopFixedArc': preset2
		};
		this.items.push({'command':'menu'});//main menu item. This one activates/deactivates the others.
		this.elements = [];
		this.coordinates = [];
		this.clickDelegates = [];
		this.vendorPrefix = this.getVendorPrefix();
		this.toggle = false;
		this.posFormat = 'position:absolute; left:{0}px; top: {1}px;z-index: {2};';
		this.touchStart = ('ontouchstart' in window) ? 'touchstart' : 'click';
		
		this.mainButton = null;
		this.mainButtonClickDelegate = null;
		this.namespace = 0;
		this.expandLevel = 0;
		this.selectedIndex = 0;
		this.rotateInClassName = 'rotatein';
		this.rotateOutClassName = 'rotateout';
		this.activeClassName = 'active';
		this.hideItemsClassName = 'hideitems';
		this.showItemsClassName = 'showitems';
		this.fadeClassName = 'fade-mainbutton';
		this.showLabelsClassName = 'showlabels';
		this.hideLabelsClassName = 'hidelabels';
		this.trail = [];
		this.lastTrail = [];
		this.buttonsList = [];
		this.preserve = ['background', 'width', 'height'];
		this.lock = false;
		
		this.unloadDelegate = $.createDelegate(this, this.unloadHandler);
		$.addEvent(window, 'unload', this.unloadDelegate );
		
		this.initialize();
	}
	extern('PathMenu', PathMenu);

	/**
		@enum
		@description Describes the role of the menu item on whether it's the main menu item or a parent menu item which means it has children under it or simply a plain child item.
	*/
	PathMenu.Role = {
		'menu': 0,
		'parent': 1,
		'item': 2
	};
	//extern(PathMenu.menuType);


	/**
		@enum
		@description Controls the positioning of menu items around the main button
	*/
	PathMenu.ExpandPattern = {
		'circle': 0,
		'lineTop': 1,
		'lineRight': 2,
		'lineBottom': 3,
		'lineLeft': 4,
		'lineMiddleHorizontal': 5,
		'lineMiddleVertical': 6,
		'leftBottomFixedArc': 7,
		'leftTopFixedArc': 8,
		'rightBottomFixedArc': 9,
		'rightTopFixedArc': 10
	};
	//extern(PathMenu.ExpandPattern);
	
	PathMenu.TrackZOrder = 0;
	
	/**
		@function
		@description Gets the current bezier curve used by the menu.
		@see #set_bezierCurve
	*/
	PathMenu.prototype.get_bezierCurve = function(){
		var bezierCurve = this.bezierCurve;
		if (bezierCurve !== null && typeof(bezierCurve) === 'object'){
			return bezierCurve;
		}else{
			return this.bezierCurvePreset[$.parseEnum(PathMenu.ExpandPattern, this.expandPattern)];
		}
	};
	extern(PathMenu.get_bezierCurve);
	/**
		@function
		@description Sets the bezierCurve value.
		@param {Object} [options.bezierCurve] The control points of a bezier curve {x0, y0, x1, y1, x2, y2, x3}. This allows you 
			to customize the curve fully. eg: {'x0':70, 'y0':45, 'x1':75, 'y1':75, 'x2':75, 'y2':75,'x3':45}. Note: We provide a visual tool that can autogenerate these values
			by simply sliding the desired control points. Look for it in the home directory.
		@see #get_bezierCurve
	*/
	PathMenu.prototype.set_bezierCurve = function(value){
		this.bezierCurve = value;
	};
	extern(PathMenu.set_bezierCurve);
	
	/**
		@function
		@description Sets the expandPattern value.
		@param {number} [options.expandPattern] Controls the positioning of menu items around the main button. Look at ExpandPattern Enum.
	*/
	PathMenu.prototype.set_expandPattern = function(value){
		if (typeof(value) === 'number'){
			this.expandPattern = value;
		}
	};
	extern(PathMenu.set_expandPattern);
	
	PathMenu.prototype.dispose = function(){
		this.cleanupDelegates(true);
		delete this.clickDelegates;
		delete this.mainButtonClickDelegate;
		if(this.resizeHandler){
			$.removeEvent(window, 'resize', this.resizeHandler);
			delete this.resizeHandler;
		}
	
		if(this.documentClickHandler){
			$.removeEvent(document, 'click', this.documentClickHandler);
			delete this.documentClickHandler;
		}
		
		if(this.scrollTouchFixHandler){
			$.removeEvent(document.body, this.touchStart, this.scrollTouchFixHandler);
		}
		
		this.activeIndex = 0;
		this.activeElem = null;
	};
	
	/**
		@function
		@private
		@ignore
		@description Cleans up all click handler delegates. This is called in dispose where 
		we need to performing a cleanup operation, and also in render ( which is usually called when rebuilding the menu)
		@param {boolean} all A value of true removes the menu items from the DOM as well.
	*/
	PathMenu.prototype.cleanupDelegates = function(all){
		var row, clickDelegate, i, j, elements = this.elements, cols, label;
		for(i = 0; i < elements.length; i++){
			cols = elements[i];
			for(j in cols){
				row = cols[j];
				clickDelegate = this.clickDelegates[i][j];
				$.removeEvent(row, this.touchStart, clickDelegate);
				if(all && row.parentNode){
					row.parentNode.removeChild(row);
				}
				
				label = document.getElementById(row.id + '_label');
				if(label){
					$.removeEvent(label, this.touchStart, clickDelegate);
					if(all && label.parentNode){
						label.parentNode.removeChild(label);
					}
				}
			}
		}
		this.clickDelegates.length = 0;
		this.elements.length = 0;
		if(this.mainButtonClickDelegate){
			$.removeEvent(this.mainButton, this.touchStart, this.mainButtonClickDelegate);
			this.mainButtonClickDelegate = null;
		}
	};
	//extern(PathMenu.cleanupDelegates);
	/**
		@function
		@description This method is automatically invoked by the constructor and includes initialization code.
	*/
	PathMenu.prototype.initialize = function(){
		var elem = this.elem, success, context = this;
		this.currentIndex = 0;
		if(!elem)return;
		
		this.id = elem.id + '_';
		if (PathMenu.TrackZOrder < this.zIndex){
			PathMenu.TrackZOrder = this.zIndex;
		}
		
		$.addCssClass(elem, 'path');

		this.create(0, this.items);
		
		this.elem.style.width = this.mainButton.offsetWidth + 'px';
		this.elem.style.height = this.mainButton.offsetHeight + 'px';

		this.snap();
		
		this.resizeHandler = $.createDelegate(this, this.resize);
		$.addEvent(window, 'resize', this.resizeHandler);
		
		if(!this.alwaysExpanded){
			if(this.touchStart === 'click'/*excludes touch enabled devices*/){
				this.documentClickHandler = $.createDelegate(this, this.documentClick);
				$.addEvent(document, 'click', this.documentClickHandler);
			}
		}
		if(this.touchStart !== 'click'){
			/*scrolling and then touching a button does not 
			trigger touchstart in android. Adding a touch handler on the body
			makes it all work. Magic!*/
			this.scrollTouchFixHandler = function(){};
			$.addEvent(document.body, this.touchStart, this.scrollTouchFixHandler);
		}
		this.test();
		if(this.expanded){
			this.expandDelayTimeoutId = window.setTimeout(function(){
				context.activateItems();
				context.toggleMainButton(1/*PathMenu.Role.parent*/);
				context.toggleMenuExpansion(-1, context.expandLevel);
				if(context.expandTimeout){
					this.expandTimeoutId = window.setTimeout(function(){
						context.collapseAll();
					}, context.expandTimeout);
				}
			}, 1500);
		}
	};
	extern(PathMenu.initialize);
	
	/**
		@private
		@function
		@description clears the expand timeout used when the menu is initially loaded with the expanded flag
	*/
	PathMenu.prototype.clearExpandTimeout = function(){
		var expandDelayTimeoutId = this.expandDelayTimeoutId,
			expandTimeoutId = this.expandTimeoutId;
		if(expandDelayTimeoutId){
			window.clearTimeout(expandDelayTimeoutId);
			this.expandDelayTimeoutId = null;
		}
		if(expandTimeoutId){
			window.clearTimeout(expandTimeoutId);
			this.expandTimeoutId = null;
		}
	};
	//extern(PathMenu.clearExpandTimeout);
	
	/**
		@function
		@description Sets a lock on the path menu UI. A lock is set by passing a value of true to this method. 
		When true the UI of the path menu does not respond to click or touch events. This is especially useful when 
		dynamically loading menu items. Setting a lock enables you to stop UI interactions while you load the menu items
		perhaps retrieving information through an ajax callback which can have a slight delay and the probability of someone
		clicking the UI before it is updated is greater.
		@param {boolean} [value=false] A value of true indicates that a lock will be set, 
		while a value of false indicates unsetting the lock. If this parameter is excluded then false is assumed by default.
	*/
	PathMenu.prototype.set_lock = function(value){
		var mainButton = this.mainButton, fade = this.fadeClassName;
		this.lock = value;
		if (value){
			$.addCssClass(mainButton, fade);
		}else{
			$.removeCssClass(mainButton, fade);
		}
	}
	extern(PathMenu.set_lock);
	
	/**
		@function
		@description Returns the interal array of menu items held by the path menu.
		@return {Array.<Object>}
	*/
	PathMenu.prototype.get_items = function(){
		return this.items;
	}
	extern(PathMenu.get_items);
	
	/**
		@function
		@description Creates and renders any newly added items found in the menu ( eg. items added through the add_items method).
		@param {string} [command=null] The command of the parent menu item whom you want to keep in an expanded state.
		Especially useful when loading menu items dynamically to maintain the level being loaded in an expanded state. 
	*/
	PathMenu.prototype.render = function(command){
		var expandLevel;
		this.namespace = 0;
		this.cleanupDelegates();
		this.trail.length = 0;
		this.create(0, this.items, command);
		this.snap();
		if (command){
			this.trail = this.lastTrail;
			this.toggleMainButton(1/*PathMenu.Role.parent*/);
			this.toggleMenuExpansion(-1, this.expandLevel);
		}
		this.set_lock(false);//release any previous locks.
		this.activateItems();
	};
	extern(PathMenu.render);
	
	/**
		@function
		@description Sets the menu items. Normally you'd want to do this in the constructor by passing the items as a parameter.
		However, sometimes we may not know the menu items until later or we might want to lazy load menu items, such as when we are dynamically building menu items.
		Use in combination with get_items(), which returns the internal array of menu items held by the menu. When using the add_item method, all your items need to be
		in object literal format and not just strings.
		@param {Object} item A string containing the command for 
		a menu item or a literal objects containing menu item specific options. This becomes a submenu of the item value parameter, which is the first parameter to this method.
		@param {Object} [subItem=null] A string containing the command for 
		a menu item or a literal objects containing menu item specific options.
		@see #get_items
	*/
	PathMenu.prototype.add_item = function(item, subItem){
		var items;
		if(typeof(subItem) !== 'undefined'){
			items = subItem['items'] || [];
			items.push(item);
			subItem['items'] = items;
		}else if (item){
			this.items.push(item);
		}
	};
	extern(PathMenu.add_item);
	
	/**
		@function
		@description This method simply tests if the menu 
		should display itself or not based on the mediaQuery filter passed in the constructor.
	*/
	PathMenu.prototype.test = function(){
		var elem = this.elem,
		success = $.mediaQuery(this.mediaFilter);
		
		if(success){
			$.removeCssClass(elem, 'hide-menu');
		}
		else{
			$.addCssClass(elem, 'hide-menu');
		}
	};
	//extern(PathMenu.test);
	
	
	/**
		@function
		@private
		@ignore
		@description The callback method in response to a document click.
	*/
	PathMenu.prototype.documentClick = function(e){
		var target = e.target || e.srcElement, tagName = 'input, select, option, button, a';
		if (target.nodeType === 1/*Node.ELEMENT_NODE*/ &&
			tagName.indexOf(target.nodeName.toLowerCase()) !== -1){
			return;
		}
		this.clearExpandTimeout();
		this.collapseAll();
	};
	//extern(PathMenu.documentClick);
	
	/**
		@function
		@description Collapses all menu items if they are expanded.
	*/
	PathMenu.prototype.collapseAll = function(){
		var expandLevel = this.expandLevel;
		if(this.toggle){
			this.expandLevel = 0;
			this.toggleMainButton(0/*PathMenu.Role.menu*/);
			this.toggleMenuExpansion(-1, expandLevel);
			this.trail.length = 0;
		}
	};
	//extern(PathMenu.collapseAll);
	
	/**
		@function
		@ignore
		@private
		@description Creates menu items looping through the various levels recursively.
		@param {number} depth 
		@param {Array} items
		@param {string|null} selectedCommand
		@param {Array|null} hierarchy
		@param {Array|null} trail
		@param {number} namespace
	*/
	PathMenu.prototype.create = function(depth, items, selectedCommand, hierarchy, trail, namespace){
		hierarchy || (hierarchy = []);
		trail || (trail = []);
		if(typeof(namespace) !== 'number'){
			namespace = 0;
		};
		var i, 
		elem, 
		root = this.elem, 
		length = 0, 
		value, 
		role = 2/*PathMenu.Role.item*/, 
		roleName,
		id = 'menuitem',
		title = '',
		text = null,
		url,
		newTab = false,
		insertMask = false,
		command = null,
		backgroundUrl = null,
		width,
		height,
		data = null,
		_items,
		_namespace = -1;
		
		if(items){
			length = items.length;
		}
		
		for(i = 0; i < length;i++){
			value = items[i];
			_items = value['items'];
			if(depth === 0 && value['command'] === 'menu'){
				role = 0/*PathMenu.Role.menu*/;
			}
			
			if(typeof(value) === 'object'){
				if(_items){
					$.log(trail.join('') + this.id + this.get_id(hierarchy, depth, i));
					hierarchy.push(i);
					trail.push('--');
					_namespace = ++this.namespace;
					
					this.create(++depth, _items, selectedCommand, hierarchy, trail, this.namespace);
					
					role = 1/*PathMenu.Role.parent*/;
					--depth;
					trail.pop();
					hierarchy.pop();
				}
			}
			
			if( typeof(value['title']) === 'string' ){
				title = value['title'];
			}
			
			if( typeof(value['url']) === 'string' ){
				url = value['url'];
			}
			
			if( typeof(value['newTab']) === 'boolean' ){
				newTab = value['newTab'];
			}
			
			if( typeof(value['insertMask']) === 'boolean' ){
				insertMask = value['insertMask'];
			}
			
			if( typeof(value['text']) === 'string' ){
				text = value['text'];
			}
			
			if( typeof(value['command']) !== 'undefined' ){
				command = value['command'];
			}else{
				command = value;//it's assumed that a simple set of string props are passed to the items collection
			}
			
			if(command === selectedCommand){
				this.expandLevel = _namespace;
			}
			
			if( typeof(value['backgroundUrl']) === 'string' ){
				backgroundUrl = value['backgroundUrl'];
			}
			
			if( typeof(value['width']) === 'number' ){
				width = value['width'];
			}
			
			if( typeof(value['height']) === 'number' ){
				height = value['height'];
			}
			
			if( typeof(value['data']) !== 'undefined' ){
				data = value['data'];
			}
			
			elem = this.createElement(command, title, url, newTab, text, backgroundUrl, width, height, data, insertMask, 
						depth, i, role, hierarchy, (role === 0/*PathMenu.Role.menu*/ ? 0 : namespace), 
						_namespace, value);
			
			if(this.touchStart === 'click' && title){
				elem.title = title;
				title = '';
			}
			if(role === 2/*PathMenu.Role.item*/){
				$.log(trail.join('') + elem.id);
			}
			
			if(role === 1/*PathMenu.Role.parent*/){
				roleName = $.parseEnum(PathMenu.Role, 2/*PathMenu.Role.item*/);
				$.addCssClass(elem, roleName);
			}
			if(role === 0/*PathMenu.Role.menu*/){
				this.selectedIndex = i;
				elem.style.position = 'relative';
				elem.style.zIndex = PathMenu.TrackZOrder + 2;
				this.mainButton = elem;
			}
			else{
				$.addCssClass(elem, 'hide-menu');
				this.buttonsList.push(elem);
			}
			roleName = $.parseEnum(PathMenu.Role, role);
			$.addCssClass(elem, roleName);
			//reset role
			role =  2/*PathMenu.Role.item*/;
			title = '';
			text = null;
			backgroundUrl = null;
			data = null;
			insertMask = false;
			command = null;
			url = null;
			newTab = false;
			height = null;
			width = null;
		}
	};
	//extern(PathMenu.create);
	
	/**
		@function
		@description Toggles the main button to display the back button and vice versa based on the namespace level. 
		@param {number} role=0 The role of the menu item, if whether it's the main menu item or a parent menu item which means it has children under it or simply a plain child item. This allows the method know
		what was the action that is causing it to toggle. eg: Was this due to the main button being clicked? ( a value of 0) 
		or was it due to a parent button being clicked? ( a value of 1), 
		or was it due to a regular button being clicked? ( A value of 2). 
		For more expressiveness use PathMenu.Role enum eg: myMenu.toggleMainButton(PathMenu.Role.menu);
		@see #Role
	*/
	PathMenu.prototype.toggleMainButton = function(role){
		if(typeof(role) !== 'number'){
			role = 0/*Pathmenu.Role.menu*/;
		}
		var level = this.expandLevel, 
		mainButton = this.mainButton, 
		zIndex = this.zIndex,
		trackZOrder = PathMenu.TrackZOrder,
		rotateInClassName = this.rotateInClassName,
		rotateOutClassName = this.rotateOutClassName,
		backClassName = 'back',
		mainButtonOptions = this.mainButtonOptions,
		backgroundFormat = 'url(\'{0}\') no-repeat center center',
		hasRotateIn = mainButton.className.indexOf(rotateInClassName)!== -1,
		mainButtonImageUrl = typeof(mainButtonOptions['backgroundUrl']) === 'string' ? mainButtonOptions['backgroundUrl'] : null,
		backButtonImageUrl = typeof(mainButtonOptions['backButtonBackgroundUrl']) === 'string' ? mainButtonOptions['backButtonBackgroundUrl'] : null;
		
		if(level > 0){
			$.addCssClass(mainButton, backClassName);
			if(backButtonImageUrl){
				mainButton.style.background = $.formatString(backgroundFormat, backButtonImageUrl);
			}
		}else{
			$.removeCssClass(mainButton, backClassName);
			if(mainButtonImageUrl){
				mainButton.style.background = $.formatString(backgroundFormat, mainButtonImageUrl);
			}
		}

		hasRotateIn = mainButton.className.indexOf(rotateInClassName)!== -1;
		if (!hasRotateIn){
			++PathMenu.TrackZOrder;
		}
		else{
			--PathMenu.TrackZOrder;
		}
		$.addCssClass(mainButton, hasRotateIn ? rotateOutClassName : rotateInClassName);
		$.removeCssClass(mainButton, hasRotateIn ? rotateInClassName : rotateOutClassName);

		if(role === 0/*PathMenu.Role.menu*/ && (!this.toggle && this.activeElem)){
			//Cleanup the element that was last clicked
			this.cleanupActiveElement();
		}
		
		mainButton.style.zIndex = PathMenu.TrackZOrder + 2;
	};
	//extern(PathMenu.toggleMainButton);
	
	/**
		@ignore
		@private
		@function 
		@description Cleans up the active element, i.e. the menu item that was clicked.
	*/
	PathMenu.prototype.cleanupActiveElement = function(){
		$.removeCssClass(this.activeElem, this.activeClassName);
		this.placeElement(this.activeElem, 0, this.activeIndex, true);
		this.activeElem = null;
		this.activeIndex = -1;
	};
	//extern(PathMenu.cleanupActiveElement);
	
	/**
		@private
		@ignore
		@function
		@description Returns the id with the proper formatting.
		@param {Array.<number>} hierarchy The current hierarchy of the menu.
		@param {number} depth The depth of the current menu.
		@param {number} i The index of the menu item whose id we want to generate.
		@param {string} name=menuitem The name of the menu item.
	*/
	PathMenu.prototype.get_id = function(hierarchy, depth, i, name){
		name = name || 'menuitem';
		if(hierarchy.length > 0){
			name += $.formatString('{0}_{1}_{2}', hierarchy.join('_'), depth, i);
		}
		else{
			name += i;
		}
		return name;
	}
	//extern(PathMenu.get_id);

	/**
		@private
		@ignore
		@function
		@description Creates the button and wires the click handler. Pretty much the meat and potatoes of a button. It all happens here.
		@param {string} value The command of the menu item. This is what distinguishes one menu button from another and is provided by the user.
		@param {string} title The title of the menu item if one is provided.
		@param {string} url The destination url to nagivate to when a menu item is clicked.
		@param {boolean} newTab Opens the destination page in a new tab when a button is clicked where the url is provided.
		@param {string} text A piece of text to display on the menu item. A span containing the text is appended into the menu item.
		@param {string} backgroundUrl An image background to display on the menu item.
		@param {number} width The width of the image set through the backgroundUrl param.
		@param {number} height The height of the image set through the backgroundUrl param.
		@param {Object} data A piece of context information you want preserved. Useful when you want to pass an argument that you can pickup when a menuitem is clicked.
		@param {number} depth The depth of the menu.
		@param {number} i The index of the menu item.
		@param {number} role The role of the menu item. It can be either 0, 1, 3 which stand for 
		1) menu ( the main menu button), 
		2) parent ( specifies that the element is a parent), 
		3) item ( a normal menu item that is not the main button nor is it a parent).
		@param {Array.<number>} hierarchy Contains the parent id of each menu item in the current hierarchy.
		@param {number} namespace The namespace within which to store the item. This is simplay a unique numeric value that helps maintain a hierarchy of child items without conflicts.
		@param {number} _namespace Same as the namespace parameter,however this is provided in case the current menu item is a parent. 
		In this case the namespace differs, since we want the parent to have the namespace of it's children while at the same time we want to store it in it's own namespace.
		@param {Object} item The item that is being created. This is the item in the items collection.
	*/
	PathMenu.prototype.createElement = function(value, title, url, newTab, text, backgroundUrl, width, height, data, insertMask, depth, i, role, hierarchy, namespace, _namespace, item){
		var x,
			root = this.elem, 
			clickDelegate,
			clickDelegates = this.clickDelegates,
			elements = this.elements,
			className = root.className,
			id = this.id + this.get_id(hierarchy, depth, i),
			mainButtonId = this.id + '_mainbutton',
			mainButton = this.mainButton,
			elem = document.getElementById(id),
			maskElem,
			span,
			isNew,
			label,
			mainButtonOptions = this.mainButtonOptions,
			backgroundFormat = 'url(\'{0}\') no-repeat center center',
			isMainButton = role === 0/*PathMenu.Role.menu*/;
		
		if(!elem && isMainButton){
			//oh maybe it's the main button then?
			elem = document.getElementById(mainButtonId);
		}
		
		if (!elem){
			//ok, we've not created this element before
			//lets do it.
			elem = document.createElement('div');

			if(isMainButton){
				elem.id = mainButtonId;
			} else{
				elem.id = id;
				if(this.expandPattern < 7/*PathMenu.ExpandPattern.leftBottomFixedArc*/){
					elem.style.position = 'absolute';
				}
			}
			isNew = true;
		}
		clickDelegate = (function(value, title, url, newTab, depth, i, role, namespace, context){
			return function(args){
				var target = args.target || args.srcElement, isActiveElem = $.containsCssClass(target, context.activeClassName);
				args = args || window.event;
				/*since we already have a handler for document click,
					we don't want this event to trickle down and bubble.
					as for touch, it's quite harmless so stop propogation.*/
				args.cancelBubble = true;
				context.clearExpandTimeout();
				if (args.stopPropagation) {
					args.stopPropagation();
				}
				
				if (!context.lock && !isActiveElem){
					context.menuItemClickHandler(args, value, title, url, newTab, depth, i, role, data, item, namespace);
				}
			};
		})(value, title, url, newTab, depth, i, role, ((role === 1/*PathMenu.Role.parent*/) ? _namespace : namespace), this);
		
		if( isNew){
			if(insertMask === true){
				maskElem = document.createElement('div');
				elem.appendChild(maskElem);
			}
			
			if(typeof(text) === 'string'){
				span = document.createElement('span');
				span.innerHTML = text;
				if (maskElem){
					maskElem.appendChild(span);
				}else{
					elem.appendChild(span);
				}
			}
			
			if(backgroundUrl){
				elem.style.background = $.formatString(backgroundFormat, backgroundUrl);
			}
			
			if(width){
				elem.style.width = width + 'px';
			}
			
			if(height){
				elem.style.height = height + 'px';
			}
			
			if(isMainButton){
				if(typeof(mainButtonOptions['backgroundUrl']) === 'string'){
					elem.style.background = $.formatString(backgroundFormat, mainButtonOptions['backgroundUrl']);
				}
				if(typeof(mainButtonOptions['width']) === 'number'){
					elem.style.width = mainButtonOptions['width'] + 'px';
				}
				if(typeof(mainButtonOptions['height']) === 'number'){
					elem.style.height = mainButtonOptions['height'] + 'px';
				}
			}
			
			root.appendChild(elem);

			if((this.expandPattern > 6/*PathMenu.ExpandPattern.lineMiddleVertical*/ && role !== 0) && (this.showLabel && title.length > 0)){
				label = document.createElement('span');
				label.className = 'captionlabel ' + this.hideLabelsClassName;
				label.innerHTML = title;
				label.id = id + '_label';
				$.setCssText(label, $.formatString(this.posFormat, 0, 0)); 
				root.appendChild(label);
				$.addEvent(label, this.touchStart,  clickDelegate)
			}
		}
		$.addEvent(elem, this.touchStart,  clickDelegate);
		
		namespace = (depth === 0 ? 0 : namespace);
		
		if(!elements[namespace]){
			elements[namespace] = [];
			clickDelegates[namespace] = [];
		}

		if(isMainButton){
			this.mainButtonClickDelegate = clickDelegate;
		}else{
			elements[namespace].splice(i, 0, elem);
			clickDelegates[namespace].splice(i, 0, clickDelegate);
		}
		return elem;
	};
	//extern(PathMenu.createElement);
	
	/**
		@private
		@ignore
		@function
		@description The handler for a menu item click event
		@param {Object} args The DOMEvent.
		@param {string} value The command of the menu item. This is what distinguishes one menu button from another and is provided by the user.
		@param {string} title The title of the menu item if one is provided.
		@param {string} url The destination url to nagivate to when a menu item is clicked.
		@param {boolean} newTab Opens the destination page in a new tab when a button is clicked where the url is provided.
		@param {number} depth The depth of the menu.
		@param {number} i The index of the menu item.
		@param {number} role The role of the menu item. It can be either 0, 1, 3 which stand for 
		1) menu ( the main menu button), 
		2) parent ( specifies that the element is a parent), 
		3) item ( a normal menu item that is not the main button nor is it a parent).
		@param {Object} data A piece of context information you want preserved. Useful when you want to pass an argument that you can pickup when a menuitem is clicked.
		@param {Object} item The item that is being created. This is the item in the items collection.
		@param {number} namespace The namespace within which to store the item. This is simplay a unique numeric value that helps maintain a hierarchy of child items without conflicts.
	*/
	PathMenu.prototype.menuItemClickHandler = function(args, value, title, url, newTab, depth, i, role, data, item, namespace){
		var mainButton = this.mainButton, 
			trail = this.trail, 
			cachedTrail = [].concat(trail), 
			expandLevel = this.expandLevel, 
			ns = namespace;
		
		if(role === 1/*PathMenu.Role.parent*/){
			trail.push(expandLevel);
			this.hide(expandLevel);//hide last level
			this.toggle = !this.toggle;
		} else if(role === 0/*PathMenu.Role.menu*/){
			if(trail.length > 0){
				ns = trail.pop();
			}
			this.activateItems();
			if(this.toggle){
				this.hide(expandLevel);
				if(expandLevel > 0){
					this.toggle = !this.toggle;
				}
			}
		}
		
		this.expandLevel = ns;
		if(role < 2/*PathMenu.Role.item*/){
			this.snap();
		}
		if(role === 2/*PathMenu.Role.item*/){
			this.expandLevel = 0;//reset
			trail.length = 0;//reset
			if(this.enableUrlHash && value){
				window.location.hash = '#' + value;
			}
		}
		
		this.selectedIndex = i;
		/*args is the original dom event argument*/

		this.toggleMainButton(role);
		this.toggleMenuExpansion((role !== 2/*PathMenu.Role.item*/ ? -1 : i), ns);
		
		cachedTrail.push(ns);
		this.lastTrail = cachedTrail;
			
		if(this.selectedItemHandler){
			this.selectedItemHandler.apply(this, [args, value, depth, role, title, data, i, item]);
		}
		
		if(this.mainButtonClickHandler && (role === 0/*PathMenu.Role.menu*/ && depth === 0)){
			this.mainButtonClickHandler.apply(this, [args]);
			return;
		}
		
		if(this.backButtonClickHandler && (role === 0/*PathMenu.Role.menu*/ && depth > 0)){
			this.backButtonClickHandler.apply(this, [args]);
			return;
		}
		
		if(this.parentButtonClickHandler && role === 1/*PathMenu.Role.parent*/){
			this.parentButtonClickHandler.apply(this, [args, value, depth, title]);
			return;
		}
		
		if(this.itemButtonClickHandler && role === 2/*PathMenu.Role.item*/){
			this.itemButtonClickHandler.apply(this, [args, value, depth, title, url]);
		}
		
		if(typeof(url) === 'string' && url.length > 0){
			window.setTimeout(function(){
				if(newTab){
					window.open(url, '_blank');
					window.focus();
				}else{
					window.location.href = url;
				}
			}, this.duration);
		}
	};
	//extern(PathMenu.menuItemClickHandler);
	
	/**
		@function
		@description Gets the toggle state of the menu items. 
		@return {boolean} true if the menu is expanded otherwise false.
	*/
	PathMenu.prototype.get_toggleState = function(){
		return this.toggle;
	};
	extern(PathMenu.get_toggleState);

	/**
		@function
		@description Shows or hides the menu items based on the toggle state.
		@param {number} activeIndex=-1 The index of the element that is being clicked.
		@param {number} namespace=0 The namespace within which child menu items are stored. 
		This is simplay a unique numeric value that helps maintain a hierarchy of child items without conflicts.
		If one is not provided then the first level of root elements are retrieved, which always have a namespace value of 0.
		@param {number} index The index of the element whose state to toggle. This param can be ignored as it is only for internal use. You only need to set the activeIndex.
	*/
	PathMenu.prototype.toggleMenuExpansion = function(activeIndex, namespace, index){
		if(typeof(activeIndex) !== 'number'){
			activeIndex = -1;
		}
		if(typeof(namespace) !== 'number'){
			namespace = this.expandLevel;
		}
		if(typeof(index) !== 'number'){
			index = 0;
		}
		var x,
		delay,
		elements = this.elements,
		level = elements[namespace],
		elem = level[index],
		label = document.getElementById(elem.id + '_label'),
		length = level.length - 1, 
		root = this.elem, 
		coor = this.coordinates,
		mainButton = this.mainButton,
		hideItemsClassName = this.hideItemsClassName,
		showItemsClassName = this.showItemsClassName,
		hideLabelsClassName = this.hideLabelsClassName,
		showLabelsClassName = this.showLabelsClassName,
		toggle = this.toggle,
		context = this;
		$.removeCssClass(elem, this.activeClassName);
		
		if(elem && elem !== mainButton){
			if(index === activeIndex){
				this.activeElem = elem;//use it later to reset the active state.
				this.activeIndex = activeIndex;// for later to reset.
				$.addCssClass(elem, this.activeClassName);
			}else{
				this.placeElement(elem, namespace, index);
				$.removeCssClass(elem, !toggle ? hideItemsClassName : showItemsClassName);
				$.addCssClass(elem, toggle ? hideItemsClassName : showItemsClassName);
			}
			if(label){
				$.removeCssClass(label, !toggle ? hideLabelsClassName : showLabelsClassName);
				$.addCssClass(label, toggle ? hideLabelsClassName : showLabelsClassName);
			}
		}
		if(index < length){
			this.toggleMenuExpansion(activeIndex, namespace, ++index);
		}
		else{
			this.toggle = !toggle;
		}
	};
	//extern(PathMenu.toggleMenuExpansion);
	
	/**
		@function
		@private
		@ignore
		@description Sets the absolute position of the element at the x/y coordinates previously determined and stored in coordinates array.
		@param {Element} elem The DOM element on whom you want to set the x/y coordinates.
		@param {number} namespace The namespace within which child menu items are stored. 
		This is simplay a unique numeric value that helps maintain a hierarchy of child items without conflicts.
		@param {number} index The index of the menu item as specified during creation in the items property passed through the constructor.
		@param {boolean} toggle=null Allows greater control on how the element is laid out. When not setting this property, the current toggle state is used.
	*/
	PathMenu.prototype.placeElement = function(elem, namespace, index, toggle){
		if(typeof(toggle) === 'undefined'){
			toggle = this.toggle;
		}
		var mainButton = this.mainButton,
		coor = this.coordinates, 
		delay = this.getDurationCssText(index),
		x = (mainButton.offsetWidth - elem.offsetWidth)/2,
		label = document.getElementById(elem.id + '_label'),
		left = toggle ? (mainButton.offsetLeft + x) : coor[namespace][index]['x'],
		top = toggle ? (mainButton.offsetTop + x) : coor[namespace][index]['y'],
		offsetWidth = elem.offsetWidth,
		offsetHeight = elem.offsetHeight;
		$.setCssText(elem, $.formatString(this.posFormat + delay,  
					left, 
					top, PathMenu.TrackZOrder), this.preserve); 
		if(label){
			top += Math.abs(offsetHeight - label.offsetHeight) / 2;
			switch(this.expandPattern){
				case 7/*PathMenu.ExpandPattern.leftBottomFixedArc*/:
				case 8/*PathMenu.ExpandPattern.leftTopFixedArc*/:
				left += offsetWidth;
				break;
				case 9/*PathMenu.ExpandPattern.rightBottomFixedArc*/:
				case 10/*PathMenu.ExpandPattern.rightTopFixedArc*/:
				left -= (label.offsetWidth);
				break;
			}
			$.setCssText(label, $.formatString(this.posFormat, left, top));
		}
	};
	//extern(PathMenu.placeElement);
	
	PathMenu.prototype.activateItems = function(){
		var elem;
			
		while(this.buttonsList.length){
			elem = this.buttonsList.shift();
			$.removeCssClass(elem, 'hide-menu');
		}
	};
	
	/**
		@function
		@private
		@ignore
		@description Hides the previous level of menu items. Called when expanding a multilevel submenu, this method allows us to collapse the previous level.
		@param {number} namespace The namespace within which child menu items are stored. 
		This is simplay a unique numeric value that helps maintain a hierarchy of child items without conflicts.
		If one is not provided then the first level of root elements are retrieved, which alaways have a namespace value of 0.
		@param {number} index=0 The index value of the menu item to hide. If one is not provided then an index value of 0 is used. 
		You don't need to pass this value. It's only for internal use by the method itself.
	*/
	PathMenu.prototype.hide = function(namespace, index){
		if(typeof(index) !== 'number'){
			index = 0;
		}
		var elements = this.elements,
		level = elements[namespace],
		elem = level[index],
		label = document.getElementById(elem.id + '_label'),
		length = level.length - 1;
		
		if(elem && elem !== this.mainButton){
			this.placeElement(elem, namespace, index);
			$.removeCssClass(elem, this.activeClassName);
			$.removeCssClass(elem, this.showItemsClassName);
			$.addCssClass(elem, this.hideItemsClassName);
			if(label){
				$.removeCssClass(label, this.showLabelsClassName);
				$.addCssClass(label, this.hideLabelsClassName);
			}
		}
		if(index < length){
			this.hide(namespace, ++index);
		}
	};
	//extern(PathMenu.hide);
	/**
		@function
		@private
		@ignore
		@description Returns X and Y coordinates based on a beizer curve. 
		@returns {Object} x and y coordinates.
	*/
	PathMenu.prototype.getBezierPos = function(x0, y0, x1, y1, x2, y2, x3, y3, t){
		var x01 = x0 + t*(x1 - x0),
		y01 = y0 + t*(y1 - y0),
		x12 = x1 + t*(x2 - x1),
		y12 = y1 + t*(y2 - y1),
		x23 = x2 + t*(x3 - x2),
		y23 = y2 + t*(y3 - y2),

		x012 = x01 + t*(x12 - x01),
		y012 = y01 + t*(y12 - y01),
		x123 = x12 + t*(x23 - x12),
		y123 = y12 + t*(y23 - y12);

		return {x: Math.round(x012 + t*(x123 - x012)),
				y: Math.round(y012 + t*(y123 - y012))};
	};
	//extern(PathMenu.getBezierPos);

	/**
		@function
		@private
		@ignore
		@description
		@param {number} index The index of the element (from a list of elements) whose position in the circle we want to find.
		@param {number} radius The radius of the circle. This shouldn't be less than the diameter of the main button.
		@param {Object} midPoint The central location around which we want to draw the circle.
		@param {number} count The number of elements in the circle.
	*/
	PathMenu.prototype.getCirclePos = function(index, radius, midPoint, count)
	{
		var part = 2 * Math.PI / count, 
		deg = part * index, 
		x = (midPoint['x'] + radius * Math.cos(deg)), 
		y = (midPoint['y'] + radius * Math.sin(deg));
		return {'x': Math.round(x), 'y': Math.round(y)};
	};
	//extern(PathMenu.getCirclePos);

	/**
		@function
		@private
		@ignore
		@description Positions menu items along a line path 
		@param {number} index The index of the element (from a list of elements) whose position in the line we want to find.
		@param {number} expandPattern The pattern of the line i.e. how menu items are aligned from the center position in a line that stretches horizontally or vertically etc.
		@param {number} diameter The width of the element whom we want positioned along a line.
		@param {number} radius The radius around the element. This shouldn't be less than the diameter of the element itself. It helps determine a distance between the menu items.
		@param {Object} midPoint The central location from where we want to draw the line.
		@param {number} count The number of elements in the line.
	*/
	PathMenu.prototype.getLinePos = function(index, expandPattern, diameter, radius, midPoint, count){
		var midX = midPoint['x'], midY = midPoint['y'], x = midX, y = midY, distance = (radius + (diameter * index)), half = count / 2,
		viewport = $.getViewport(), scrollPos = $.getScrollPos(), scrollX = scrollPos['x'], scrollY = scrollPos['y'], i, 
		scrollbarThickness = this.scrollbarThickness,
		scrollbarThicknessX = scrollX > 0 ? scrollbarThickness : 0,
		scrollbarThicknessY = scrollY > 0 ? scrollbarThickness : 0,
		screenWidth = (viewport['width'] - scrollbarThicknessX), 
		screenHeight = (viewport['height'] - scrollbarThicknessY);
		
		switch(expandPattern){
			case 1/*PathMenu.ExpandPattern.lineTop*/:
				y -= distance;
			break;
			case 2/*PathMenu.ExpandPattern.lineRight*/:
				x += distance;
			break;
			case 3/*PathMenu.ExpandPattern.lineBottom*/:
				y += distance;
			break;
			case 4/*PathMenu.ExpandPattern.lineLeft*/:
				x -= distance;
			break;
			case 5/*PathMenu.ExpandPattern.lineMiddleHorizontal*/:
			case 6/*PathMenu.ExpandPattern.lineMiddleVertical*/:
			distance = (radius + (diameter * (index >= half ? index - half : index)));
			if (this.currentIndex === 0){
				this.currentIndex = half;
			}
			if(expandPattern === 5){
				if(index >= half){
					x -= distance;
				}else{
					x += distance;
				}
			}else{
				if(index >= half){
					y -= distance;
				}else{
					y += distance;
				}
			}
			break;
		}

		if(expandPattern === 2 || expandPattern === 4 || expandPattern === 5){
			if ((x + diameter) > screenWidth + scrollX || (x - scrollX) < 0){
				//horizontal patterns, make adjustments so menu items are always visible.
				distance = radius + (diameter * this.currentIndex++);
				if (x > midX){
					x = midX - distance;
				}else{
					x = midX + distance;
				}
			}
		}
		else if(expandPattern === 1 || expandPattern === 3 || expandPattern === 6){
			//vertical patterns, make adjustments so menu items are always visible.
			if ((y + diameter) > screenHeight + scrollY || (y - scrollY) < 0){
				distance = radius + (diameter * this.currentIndex++);
				if ( y > midY){
					y = midY - distance;
				}else{
					y = midY + distance;
				}
			}
		}

		return {'x': x, 'y': y};
	};
	//extern(PathMenu.getLinePos);
	/**
		@function
		@private
		@ignore
		@description Simply calculates the percentage of the given value p from t.
		@param {number} t The total value from which to derive a percentage.
		@param {number} p The percentage to retrieve.
		@returns {number} The result of the percentage eg: 25% percent of 100 = 25.
	*/
	PathMenu.prototype.percentOf = function(t, p){
		return Math.round((t / 100) * p);
	};
	//extern(PathMenu.percentOf);

	/**
		@function
		@private
		@ignore
		@description Callback executed when window is resized.
	*/
	PathMenu.prototype.resize = function(){
		/*workaround event firing more than once in google chrome. we only want to handle this once.*/
		var context = this;
		if(!this.flag){
			this.flag = true;
			window.setTimeout(function(){
				context.flag = false;//reset flag
				context.test();
				context.snap(true);
			}, 0);
		}
	};
	//extern(PathMenu.resize);

	/**
		@function
		@description Snaps the buttons positioning them in a curve. This method is called also when the window resizes ensuring that the positions are never shifted.
		@param {boolean} onResize=false snap needs to know if it's being called from within a window.onresize handler.
	*/
	PathMenu.prototype.snap = function(onResize){
		var i,
		j,
		k,
		x,
		x0,
		y0,
		x1, 
		y1, 
		x2, 
		y2, 
		x3,
		y3,
		pos,
		tPos,
		top,
		elem,
		elems,
		length,
		delay,
		root = this.elem, 
		mainButton = this.mainButton,
		mainButtonWidth = mainButton.offsetWidth,
		mainButtonHeight = mainButton.offsetHeight,
		levels = this.elements, 
		percentOf = this.percentOf,
		points,
		coordinates = this.coordinates,
		namespace = this.namespace,
		midPoint,
		radius = this.radius,
		expandPattern = this.expandPattern,
		fixed = expandPattern >= 7/*PathMenu.ExpandPattern.leftBottomFixedArc*/,
		toggle = false;
		if(fixed){
			points = this.bezierCurve || this.bezierCurvePreset[$.parseEnum(PathMenu.ExpandPattern, expandPattern)];
			x0 = points['x0'];
			y0 = percentOf(x0, points['y0']);
			x1 = percentOf(x0, points['x1']); 
			y1 = percentOf(x0, points['y1']); 
			x2 = percentOf(x0, points['x2']); 
			y2 = percentOf(x0, points['y2']);
			x3 = percentOf(x0, points['x3']);
			y3 = x0;
		}
		/*
			$.parseEnum(PathMenu.Role, 2 /-PathMenu.Role.item-/ );
		*/
		for(i = 0; i <= namespace; i++){
			i = parseInt(i, 10);
			elems = levels[i];
			length = elems.length;
			for(j = 0; j < length;j++){
				elem = elems[j];
				//mainbutton has to always be bigger than the item buttons.
				x = Math.abs(mainButtonWidth - elem.offsetWidth)/2;
				midPoint = {'x': mainButton.offsetLeft + x, 'y': mainButton.offsetTop + x};
				if(fixed){
					pos = this.getBezierPos(x0*j, y0*j, x1*j, y1*j, x2*j, y2*j, x3*j, y3*j, j/length);
					switch (expandPattern){
						case 8/*PathMenu.ExpandPattern.leftTopFixedArc*/:
						case 10/*PathMenu.ExpandPattern.rightTopFixedArc*/:
							k = (length - 1) - j;
							tPos = this.getBezierPos(x0*k, y0*k, x1*k, y1*k, x2*k, y2*k, x3*k, y3*k, (k/length)-1);
							if(expandPattern === 8/*PathMenu.ExpandPattern.leftTopFixedArc*/){
								pos.x = tPos.x;
								if(length === 1){
									pos.x = tPos.x + mainButtonWidth;
								}
							}
							else{
								pos.x = -tPos.x;
								if(length === 1){
									pos.x = -(tPos.x + elem.offsetWidth);
								}
							}
						break;
						case 9/*PathMenu.ExpandPattern.rightBottomFixedArc*/:
							pos.x = -pos.x;
						break;
					}
				}else{
					if(expandPattern === 0/*PathMenu.ExpandPattern.circle*/){
						radius = this.radius < mainButton.offsetWidth ? mainButton.offsetWidth : this.radius;
						pos = this.getCirclePos(j, radius, midPoint, length);
					}else{
						pos = this.getLinePos(j, expandPattern, elem.offsetWidth, radius, midPoint, length);
					}
				}
				if(!coordinates[i]){
					coordinates[i] = [];
				}
				coordinates[i][j] = {'x': pos.x, 'y': pos.y};
			}
			this.currentIndex = 0;//reset
		}
		this.position();
		//placement is based on mainButton
		for(i = 0; i <= namespace; i++){
			i = parseInt(i, 10);
			elems = levels[i];
			length = elems.length;
			
			toggle = !(i === this.expandLevel && (onResize && this.toggle));
			
			for(j = 0; j < length;j++){
				elem = elems[j];
				if(elem){
					this.placeElement(elem, i, j, toggle);
				}
			}
			
			toggle = false;
		}
	};
	//extern(PathMenu.snap);

	/**
		@function
		@private
		@ignore
		@description Positions the menu in the bottom left corner of the window and makes it fixed. 
	*/
	PathMenu.prototype.position = function(){
		if (! this.elements[0] || !this.elements[0][0] || (this.expandPattern < 7/*PathMenu.ExpandPattern.leftBottomFixedArc*/)){return;}
		var i,
		elem = this.elem,
		expandPattern = this.expandPattern,
		left = this.paddingLeft,
		viewport = $.getViewport(),
		mainButton = this.mainButton,
		itemButton = this.elements[0][0],
		coordinates = this.coordinates[this.expandLevel], 
		length = coordinates.length,
		delay = this.getDurationCssText(length),
		scrollbarThickness,
		dockBottom = (expandPattern === 7/*PathMenu.ExpandPattern.leftBottomFixedArc*/ ||
			expandPattern === 9/*PathMenu.ExpandPattern.rightBottomFixedArc*/),
		dockRight = (expandPattern === 10/*PathMenu.ExpandPattern.rightTopFixedArc*/ ||
			expandPattern === 9/*PathMenu.ExpandPattern.rightBottomFixedArc*/),
		height = coordinates[length - 1].y;//the last elements position is good.

		elem.style.position = 'fixed';
		elem.style.zIndex = this.zIndex;
		
		if(height === 0){
			height = (itemButton.offsetHeight * length);
		}

		if (dockRight){
			scrollbarThickness = document.body.offsetHeight > viewport.height ? this.scrollbarThickness : 0;
			left = viewport.width - (mainButton.offsetWidth + this.paddingRight + scrollbarThickness);
		}
		if (dockBottom){
			elem.style.top = '';
			elem.style.bottom = (height - elem.offsetHeight) + mainButton.offsetHeight + this.paddingBottom + 'px';
		}
		else{
			height = 0;
			elem.style.top = this.paddingTop + 'px';
		}
		elem.style.left = left + 'px';
		
		$.setCssText(mainButton, $.formatString((this.posFormat + delay), 0, height, PathMenu.TrackZOrder + 2), this.preserve);
	};
	//extern(PathMenu.position);
	
	/**
		@ignore
		@private
		@function
		@description Returns only the vendor prefix if applicable. The vendor prefix returned is in the format "vedorprefix".
		@param {string=} prop The CSS3 property whose vendor prefix you want returned. This is optional and not required. 
		By default this method will query the Transition property and based on the availability of this property a vendor prefix will be constructed. 
		@example
		//within an object that inherits BaseEffect
		var prefix = this.getVendorPrefix();
		console.log(prefix);//outputs one of these values : 'Webkit', 'Moz', 'O', 'ms', ''
	*/
	PathMenu.prototype.getVendorPrefix = function(prop){
		prop = prop || 'Transition';
		var div = document.createElement( "div" ),
		prefix = ['Webkit', 'Moz', 'O', 'MS', ''],
		name,
		p = [prop, prop.toLowerCase()], i, j;
		for(i in prefix){
			for(j in p){
				if((prefix[i] + p[j]) in div.style){ 
					name = prefix[i].toLowerCase();
					return {'f': $.formatString('-{0}-', name), 'o': name};
				}
			}
		}
		return {'f': '', 'o': ''};
	};
	//extern(PathMenu.getVendorPrefix);

	/**
		@ignore
		@private
		@function
		@description A utility method to get the duration in css text.
		@param {number=} index The index of the element onto which we will apply the duration .
		@see #applyDurationCssText
	*/
	PathMenu.prototype.getDurationCssText = function(index){
		var delay = (index+1) * 30;
		return $.formatString('{0}transition-delay: {1}ms;', this.vendorPrefix['f'], delay);
	};
	//extern(PathMenu.getDurationCssText);

	/**
		@private
	*/		
	PathMenu.prototype.unloadHandler = function () {
		if (this.unloadDelegate) {
			$.removeEvent(window, 'unload', this.unloadDelegate );
		}
		delete this.unloadDelegate;
		this.dispose();
	};
}(window, document, window['$m']));
