// Generated by CoffeeScript 1.6.1
(function() {
  var _this = this;

  window.Alert = (function() {

    function Alert(selector) {
      var _this = this;
      this.hide = function() {
        return Alert.prototype.hide.apply(_this, arguments);
      };
      this.show = function() {
        return Alert.prototype.show.apply(_this, arguments);
      };
      this.div = $(selector);
      this.div.on("click", this.hide);
    }

    Alert.prototype.show = function() {
      this.div.slideDown(500).fadeTo(500, 1);
      return window.scrollTo(0, 0);
    };

    Alert.prototype.hide = function() {
      return this.div.fadeTo(500, 0).slideUp(500);
    };

    return Alert;

  })();

  module.exports = window.Alert;

}).call(this);
