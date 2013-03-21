// Generated by CoffeeScript 1.6.2
(function() {
  ko.bindingHandlers.datepicker = {
    init: function(element, valueAccessor, allBindingsAccessor) {
      var customization, isValid, options;

      options = allBindingsAccessor().datepickerOptions;
      isValid = function() {
        return true;
      };
      if (((options != null ? options.start : void 0) != null) && ((options != null ? options.end : void 0) != null)) {
        isValid = function(date) {
          var value;

          value = date.valueOf();
          return value >= options.start.valueOf() && value <= options.end.valueOf();
        };
        customization = {
          onRender: function(date) {
            if (isValid(date)) {
              return "";
            } else {
              return "disabled";
            }
          }
        };
      }
      $(element).datepicker(customization);
      ko.utils.registerEventHandler(element, "changeDate", function(event) {
        var value;

        value = valueAccessor();
        if (isValid(event.date) && ko.isObservable(value)) {
          value(event.date);
          return $(element).datepicker("hide");
        }
      });
      return ko.utils.registerEventHandler(element, "change", function() {
        var date, value;

        value = valueAccessor();
        date = new Date(element.value);
        if (isValid(date) && ko.isObservable(value)) {
          return value(date);
        }
      });
    },
    update: function(element, valueAccessor) {
      var widget;

      widget = $(element).data("datepicker");
      if (widget) {
        widget.date = ko.utils.unwrapObservable(valueAccessor());
        if (!widget.date) {
          return;
        }
        if (_.isString(widget.date)) {
          widget.date = new Date(widget.date);
        }
        return widget.setValue(widget.date);
      }
    }
  };

}).call(this);
