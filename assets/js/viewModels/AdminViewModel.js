// Generated by CoffeeScript 1.6.1
(function() {
  var _this = this;

  global.UserViewModel = require("../assets/js/viewModels/UserViewModel");

  window.AdminViewModel = (function() {

    function AdminViewModel() {
      var _this = this;
      this.doSearch = function(data, event) {
        return AdminViewModel.prototype.doSearch.apply(_this, arguments);
      };
      this.readableStatus = function(status) {
        return AdminViewModel.prototype.readableStatus.apply(_this, arguments);
      };
      this.name = "Петя";
      this.statuses = ko.observableArray([
        {
          text: "new",
          checked: false
        }, {
          text: "emailsent",
          checked: false
        }, {
          text: "paid",
          checked: false
        }
      ]);
      this.users = ko.observableArray([]);
      this.search = ko.observable("");
    }

    AdminViewModel.prototype.doSignOut = function() {
      return window.location.href = "registration.html";
    };

    AdminViewModel.prototype.isFiltered = function(text) {
      var allUnchecked, status, _i, _len, _ref;
      allUnchecked = true;
      _ref = this.statuses();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        status = _ref[_i];
        if (status.checked) {
          allUnchecked = false;
        }
        if (status.text === text && status.checked) {
          return true;
        }
      }
      return allUnchecked;
    };

    AdminViewModel.prototype.readableStatus = function(status) {
      switch (status) {
        case "new":
          return "Новый";
        case "emailsent":
          return "Ожидаем оплаты";
        case "paid":
          return "Оплачен";
      }
    };

    AdminViewModel.prototype.doSearch = function(data, event) {
      var _this = this;
      if (event.which === 13) {
        $("#search_query").blur();
        setTimeout(function() {
          return cpanel.loadUsers();
        }, 30);
        event.preventDefault();
        false;
      }
      return true;
    };

    return AdminViewModel;

  })();

  module.exports = window.AdminViewModel;

}).call(this);
