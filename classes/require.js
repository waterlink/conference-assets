// Generated by CoffeeScript 1.6.2
(function() {
  window.global = window;

  global.modules = {};

  global.require = function(path) {
    var p;

    if (!global.modules[path]) {
      global.modules[path] = {
        exports: {},
        path: path
      };
      p = $.ajax({
        url: "" + path + ".js",
        cache: false,
        dataType: "text",
        context: global.modules[path],
        async: false
      });
      p.done(function(data) {
        var module;

        module = global.modules[path];
        eval(data);
        return console.log("evaled");
      });
      p.error(function() {
        return console.warn("problem loading '" + path + "' module: ", arguments);
      });
      console.log("returning");
    }
    return global.modules[path].exports;
  };

}).call(this);
