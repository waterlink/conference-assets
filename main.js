// Generated by CoffeeScript 1.6.1
(function() {
  var Main;

  global.Backend = require("../classes/backend");

  global.Restfull = require("../classes/restfull");

  global.User = require("../classes/user");

  Main = (function() {

    function Main() {
      console.log("Application initialized");
    }

    Main.prototype.run = function() {
      console.log("Application started");
      return this.check();
    };

    Main.prototype.check = function() {
      console.log(new Backend);
      console.log(new Restfull);
      return console.log(new User);
    };

    return Main;

  })();

  module.exports = new Main;

}).call(this);
