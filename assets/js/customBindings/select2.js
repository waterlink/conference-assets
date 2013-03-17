// Generated by CoffeeScript 1.6.1
(function() {

  ko.bindingHandlers.select2 = {
    init: function(element, valueAccessor) {
      $(element).select2(valueAccessor());
      return ko.utils.domNodeDisposal.addDisposeCallback(element, function() {
        return $(element).select2('destroy');
      });
    },
    update: function(element) {
      return $(element).trigger('change');
    }
  };

}).call(this);
