// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  global.CpanelUserViewModel = require("../assets/js/viewModels/CpanelUserViewModel");

  global.OperatorViewModel = require("../assets/js/viewModels/OperatorViewModel");

  window.AdminViewModel = (function() {

    function AdminViewModel() {
      this.isActive = __bind(this.isActive, this);

      this.doBackToUsersLeft = __bind(this.doBackToUsersLeft, this);

      this.doBackToUsersRight = __bind(this.doBackToUsersRight, this);

      this.cancelAddOperator = __bind(this.cancelAddOperator, this);

      this.confirmAddOperator = __bind(this.confirmAddOperator, this);

      this.newOperator = __bind(this.newOperator, this);

      this.goOperatorPage = __bind(this.goOperatorPage, this);

      this.prevPage = __bind(this.prevPage, this);

      this.nextPage = __bind(this.nextPage, this);

      this.doSearch = __bind(this.doSearch, this);

      this.readableStatus = __bind(this.readableStatus, this);

      var _this = this;
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
      this.page = ko.observable(0);
      this.userCount = ko.observable(0);
      this.users = ko.observableArray([]);
      this.search = ko.observable("");
      this.prevPageClass = ko.computed(function() {
        if (_this.page() === 0) {
          return "btn disabled";
        }
        return "btn";
      });
      this.nextPageClass = ko.computed(function() {
        if (_this.userCount() < global.cpanelPageLimit) {
          return "btn disabled";
        }
        return "btn";
      });
      this.isAdmin = ko.computed(function() {
        return __indexOf.call(cpanel.group, "admin") >= 0;
      });
      this.operators = ko.observableArray([]);
      if (this.isAdmin()) {
        cpanel.loadOperators();
      }
      this.addingOperator = ko.observable(false);
      this.operatorLogin = ko.observable("");
      this.operatorPassword = ko.observable("");
      this.operatorConfirmPassword = ko.observable("");
      this.backToUsersLeftIsHidden = ko.observable(true);
      this.backToUsersRightIsHidden = ko.observable(true);
      this.activeUser = ko.observable(false);
      this.searchData = global.searchData;
      this.anotherWrapper = function(what) {
        return "Другое (" + what + ")";
      };
      this.selectQuery = function(searchData, anotherAllowed) {
        if (anotherAllowed == null) {
          anotherAllowed = true;
        }
        return function(query) {
          var data;
          data = _this.searchData[searchData].filter(function(x) {
            return x.toLowerCase().match(query.term.toLowerCase());
          });
          if (anotherAllowed) {
            data.push(_this.anotherWrapper(query.term));
          }
          return query.callback({
            results: $.map(data)
          }, function(x) {
            var obj;
            return obj = {
              id: x,
              text: x
            };
          });
        };
      };
      this.selectOptions = function(searchData, defaultValue) {
        var data;
        if (defaultValue == null) {
          defaultValue = false;
        }
        data = _this.searchData[searchData];
        if (defaultValue) {
          if (__indexOf.call(data, defaultValue) < 0) {
            data.push(defaultValue);
          }
        }
        return data;
      };
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

    AdminViewModel.prototype.nextPage = function() {
      if (this.userCount() === global.cpanelPageLimit) {
        cpanel.page++;
        this.page(cpanel.page);
        cpanel.filter.skip += global.cpanelPageLimit;
        return cpanel.loadUsers();
      }
    };

    AdminViewModel.prototype.prevPage = function() {
      if (this.page() > 0) {
        cpanel.page--;
        this.page(cpanel.page);
        cpanel.filter.skip -= global.cpanelPageLimit;
        return cpanel.loadUsers();
      }
    };

    AdminViewModel.prototype.goOperatorPage = function() {
      var _this = this;
      if (cpanel.operator_page) {
        return;
      }
      $("#operators_li").addClass("active");
      this.initialOffset = $("#user_page").offset();
      if (cpanel.active_page) {
        cpanel.active_page.addClass("cpanel-navigation-goaway-right");
        cpanel.active_page = void 0;
        $('.hidden-page').remove();
        $("#user_page").removeClass("cpanel-navigation-goaway-left");
      }
      $("#user_page").addClass("cpanel-navigation-goaway-right");
      return setTimeout(function() {
        var operator_page;
        operator_page = $(".operator-page .container");
        operator_page.css({
          position: "fixed",
          left: _this.initialOffset.left,
          top: _this.initialOffset.top
        });
        operator_page.removeClass("cpanel-navigation-goaway-left");
        cpanel.operator_page = operator_page;
        setTimeout(function() {
          return operator_page.attr("style", "");
        }, 500);
        _this.backToUsersRightIsHidden(false);
        return _this.backToUsersLeftIsHidden(true);
      }, 50);
    };

    AdminViewModel.prototype.newOperator = function() {
      return this.addingOperator(true);
    };

    AdminViewModel.prototype.confirmAddOperator = function(d, e) {
      var p,
        _this = this;
      if (this.operatorPassword() !== this.operatorConfirmPassword()) {
        alert("Пароли не совпадают!");
        return;
      }
      $(e.target).button("loading");
      p = cpanel.rest.post("index", {
        login: this.operatorLogin(),
        password: this.operatorPassword()
      });
      return p.done(function(data) {
        $(e.target).button("reset");
        _this.cancelAddOperator();
        if (data && data.error) {
          return alert(data.error);
        } else {
          return cpanel.loadOperators();
        }
      });
    };

    AdminViewModel.prototype.cancelAddOperator = function() {
      this.addingOperator(false);
      this.operatorLogin("");
      this.operatorPassword("");
      return this.operatorConfirmPassword("");
    };

    AdminViewModel.prototype.doBackToUsersRight = function() {
      $("#user_page").css({
        position: "fixed",
        left: this.initialOffset.left,
        top: this.initialOffset.top
      });
      $("#user_page").removeClass("cpanel-navigation-goaway-right");
      $("#user_page").removeClass("cpanel-navigation-goaway-left");
      cpanel.operator_page = $(".operator-page .container");
      if (cpanel.operator_page.length) {
        $("#operators_li").removeClass("active");
        cpanel.operator_page.addClass("cpanel-navigation-goaway-left");
        cpanel.operator_page = void 0;
      }
      setTimeout(function() {
        return $("#user_page").attr("style", "");
      }, 500);
      return this.backToUsersRightIsHidden(true);
    };

    AdminViewModel.prototype.doBackToUsersLeft = function() {
      $("#user_page").css({
        position: "fixed",
        left: this.initialOffset.left,
        top: this.initialOffset.top
      });
      $("#user_page").removeClass("cpanel-navigation-goaway-left");
      if (cpanel.active_page) {
        cpanel.active_page.addClass("cpanel-navigation-goaway-right");
        cpanel.active_page = void 0;
      }
      setTimeout(function() {
        return $("#user_page").attr("style", "");
      }, 500);
      return this.backToUsersLeftIsHidden(true);
    };

    AdminViewModel.prototype.isActive = function(id) {
      return this.activeUser() === id;
    };

    return AdminViewModel;

  })();

  module.exports = window.AdminViewModel;

}).call(this);
