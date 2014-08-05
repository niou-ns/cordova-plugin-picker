'use strict';
module.exports = (function() {

  /**
   * Creates an instance of a Picker that encapsulates a set of options or choices and exposes methods of showing, hiding and
   * updating the list of choices and optional properties that function as callbacks for various events generated by the picker.
   *
   * @class Picker
   * @constructor
   */
  function Picker() {}

  var win = function(result) {
    console.log('win returned ' + result.event + ' with row ' + result.row + ' and component ' + result.component);
    if (result.event === 'close' || result.event === 'select') {
      //TODO: if this is done on select, does it need to be done on close as well? Select should have already been fired?
      var selected, oldValue;
      if (this._htmlOptions.selectedIndex >= 0)
        oldValue = this._htmlOptions.item(this._htmlOptions.selectedIndex);
      if (result.row >= 0) 
        selected = this._htmlOptions.item(result.row);
      if (result.event === 'close' && typeof this.onClose == 'function') { 
        this._focusedIndex = undefined;
        this._htmlOptions.selectedIndex = result.row;
        this.onClose(selected, oldValue, this._htmlOptions);
      } else if (result.event === 'select' && typeof this.onSelect == 'function') {
        this._focusedIndex = result.row;
        this.onSelect(selected, oldValue, this._htmlOptions);
      }
    } else if (result.event === 'show' && typeof this.onShow == 'function')
      this.onShow();
    else if (result.event === 'change' && typeof this.onOptionsChange == 'function')
      this.onOptionsChange(this._htmlOptions);
    else if (result.event === 'error' && typeof this.onError == 'function') 
      this.onError(result.error);
  };

  var translateToNative = function(htmlOptions) {
    var out = [];
    for (var i = 0; i < htmlOptions.length; i++) {
      out.push({text: htmlOptions[i].text});
    }
    console.out("pushing " + out.length + " options to picker controller");
    return out;
  };

  Picker.prototype = {

    /**
     * @class Picker
     * @property options
     */
    get options() {
      return this._htmlOptions;
    },
    set options(newOptions) {
      this.update(newOptions);
    },

    /**
     * @class Picker
     * @method onShow
     */
    /**
     * @class Picker
     * @method onHide
     * @param {Object} newly selected option.
     * @param {Object} previously selection option.
     */ 
    /**
     * @class Picker
     * @method onOptionsChange
     */
    /**
     * @class Picker
     * @method onSelect
     * @param {Object} newly selected option.
     * @param {Object} previously selected option.
     */
    /**
     * Shows the picker if it not already visible and invokes the onShow function if it is defined on this Picker.
     * 
     * @class Picker
     * @method show
     */
    show: function() {
      console.log('showing picker');
      cordova.exec(win.bind(this), this.onError, 'Picker', 'show', [translateToNative(this._htmlOptions), (this._focusedIndex || this._htmlOptions.selectedIndex || 0)]);
    },

    /**
     * Hides this picker if is visible and invokes the onHide function if it is defined on this Picker.
     *
     * @class Picker
     * @method hide
     */
    hide: function() {
      cordova.exec(win.bind(this), this.onError, 'Picker', 'hide', []);
    },

    /**
     * updates the options exposed as choices in the picker and invokes the onOptionsChange callback if it is defined
     * on this Picker.
     * 
     * @class Picker
     * @method update
     * @param {Array} list of options to display in the picker.
     */
    update: function(newOptions, resetSelection) {
      this._htmlOptions = newOptions || this._htmlOptions;
      if (newOptions === undefined || newOptions.length === 0)
        return;
      if (resetSelection || !this._focusedIndex)
        this._focusedIndex = this._htmlOptions.selectedIndex;
      cordova.exec(win.bind(this), this.onError, 'Picker', 'updateOptions', [translateToNative(this._htmlOptions), (this._focusedIndex || this._htmlOptions.selectedIndex || 0)]);
    }
  };

  /**
   * @class navigator.picker
   * @singleton
   */   
  return {
    echo: function(msg, success, failure) {
      console.log('Invoking CDVPicker.echo');
      cordova.exec(success, failure, 'Picker', 'echo', [msg]);
    },

    /**
     * @class navigator.picker
     * @method create
     */
    create: function() {
      return new Picker();
    }
  };
})();