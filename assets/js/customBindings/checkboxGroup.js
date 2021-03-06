// Generated by CoffeeScript 1.6.2
(function() {
  ko.bindingHandlers.checkboxGroup = {
    init: function(element, valueAccessor, allBindings, data, context) {
      var $element, array, index;

      array = valueAccessor().array;
      index = valueAccessor().index();
      $element = $(element);
      $element.on("click", function() {
        array()[index].checked = !array()[index].checked;
        return array.valueHasMutated();
      });
      return ko.computed({
        disposeWhenNodeIsRemoved: element,
        read: function() {
          return $element.toggleClass("active", array()[index].checked);
        }
      });
    }
  };

}).call(this);
