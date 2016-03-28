'use strict';

module.exports = (function() {

  var win = function(result) {
    console.log(result);
    if (result.event === 'close' || result.event === 'select') {
      //TODO: if this is done on select, does it need to be done on close as well? Select should have already been fired?
      var selected, oldValue;
      //if (this._htmlOptions.selectedIndex >= 0) {}

      if (result.row >= 0) {}

      if (result.event === 'close' && typeof this.onClose === 'function') {
        this._focusedIndex = undefined;
        //this._htmlOptions.selectedIndex = result.row;
        //this.onClose(selected, oldValue, this._htmlOptions);
      } else if (result.event === 'select' && typeof this.onSelect === 'function') {
        this._focusedIndex = result.row;
        //this.onSelect(selected, oldValue, this._htmlOptions);
      }
    } else if (result.event === 'show' && typeof this.onShow === 'function')
      this.onShow();
    else if (result.event === 'change' && typeof this.onOptionsChange === 'function') {}

    else if (result.event === 'next' && typeof this.onNext === 'function')
      this.onNext();
    else if (result.event === 'back' && typeof this.onBack === 'function')
      this.onBack();
    else if (result.event === 'error' && typeof this.onError === 'function')
      this.onError(result.error);
  };

  /**
   * @class navigator.picker
   * @singleton
   */
  return {
      show: function(successCallback, errorCallback, dataArray, selectedArray) {
        cordova.exec(successCallback, errorCallback, 'Picker', 'show',
          [
            dataArray,
            selectedArray,
            (typeof this.onBack === 'function'),
            (typeof this.onNext === 'function')
          ]);
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
    }
})();
