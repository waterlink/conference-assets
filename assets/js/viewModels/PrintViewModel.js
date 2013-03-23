// Generated by CoffeeScript 1.6.2
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  global.Restfull = require("../classes/restfull");

  global.Auth = require("../classes/auth");

  window.PrintViewModel = (function() {
    function PrintViewModel() {
      this.redirectToLogin = __bind(this.redirectToLogin, this);
      this.loadData = __bind(this.loadData, this);      this.rest = new Restfull;
      this.auth = new Auth(this.rest);
      this.auth.login({
        ok: this.loadData,
        fail: this.redirectToLogin
      });
      this.users = ko.observableArray();
    }

    PrintViewModel.prototype.loadData = function() {
      var p,
        _this = this;

      p = this.rest.get("user");
      return p.done(function(users) {
        var sortBy, user, _i, _len, _ref, _results;

        sortBy = function(a, b) {
          return a.id > b.id;
        };
        _ref = users.sort(sortBy);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          user = _ref[_i];
          _results.push(_this.users.push(new UserViewModel(user)));
        }
        return _results;
      });
    };

    PrintViewModel.prototype.redirectToLogin = function() {
      return global.location = "login.html#print.html";
    };

    return PrintViewModel;

  })();

}).call(this);