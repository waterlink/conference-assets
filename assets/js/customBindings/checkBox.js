// Generated by CoffeeScript 1.6.2
(function() {
  var onUpdate;

  onUpdate = function(element, valueAccessor) {
    var checkbox, value;

    value = valueAccessor();
    checkbox = "<i class='icon-ok'></i>";
    return $(element).html(value() ? checkbox : "-");
  };

  ko.bindingHandlers.checkbox = {
    init: onUpdate,
    update: onUpdate
  };

}).call(this);
