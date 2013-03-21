// Generated by CoffeeScript 1.6.2
(function() {
  var Cpanel, statusGraph, statuses;

  global.Restfull = require("../classes/restfull");

  global.User = require("../classes/user");

  statuses = {
    "new": "Новый",
    "emailsent": "Письмо отослано",
    "paid": "Оплачено"
  };

  statusGraph = {
    next: {
      "new": "emailsent",
      "emailsent": "paid"
    },
    prev: {
      "emailsent": "new",
      "paid": "emailsent"
    }
  };

  Cpanel = (function() {
    function Cpanel() {
      var _this = this;

      this.rest = new Restfull;
      this.authenticated({
        ok: function() {
          return _this.showOperatorLogin();
        },
        fail: function() {
          return _this.redirectToLogin();
        }
      });
      $(document).ready(function() {
        return _this.ready();
      });
    }

    Cpanel.prototype.ready = function() {
      this.setup();
      return this.loadUsers();
    };

    Cpanel.prototype.authenticated = function(callbacks) {
      var p,
        _this = this;

      p = this.rest.get("index");
      p.error(callbacks.fail);
      return p.done(function(data) {
        if (data && data.whois) {
          _this.whois = data.whois;
          _this.group = data.group;
          return callbacks.ok();
        } else {
          return callbacks.fail();
        }
      });
    };

    Cpanel.prototype.redirectToLogin = function() {
      return global.location = "login.html";
    };

    Cpanel.prototype.showOperatorLogin = function() {
      return $('#operator_login_content').text("@" + this.whois);
    };

    Cpanel.prototype.logoff = function() {
      var p,
        _this = this;

      p = this.rest["delete"]("index");
      return p.done(function() {
        return _this.redirectToLogin();
      });
    };

    Cpanel.prototype.setup = function() {
      var me,
        _this = this;

      me = this;
      this.filter = {};
      $('#operator_logoff').click(function() {
        return _this.logoff();
      });
      return $('.status-filter').click(function() {
        return me.statusFilterChanged($(this).attr("rel"));
      });
    };

    Cpanel.prototype.statusFilterChanged = function(status) {
      if (this.filter.status) {
        if (this.filter.status === status) {
          $(".status-filter[rel=\"" + status + "\"]").removeClass("active");
          delete this.filter.status;
        } else {
          $(".status-filter[rel=\"" + this.filter.status + "\"]").removeClass("active");
          this.filter.status = status;
          $(".status-filter[rel=\"" + status + "\"]").addClass("active");
        }
      } else {
        this.filter.status = status;
        $(".status-filter[rel=\"" + status + "\"]").addClass("active");
      }
      return this.loadUsers();
    };

    Cpanel.prototype.loadUsers = function() {
      var p, realUsers, userView,
        _this = this;

      p = this.rest.get("user", this.filter);
      userView = $("#user_view");
      realUsers = userView.find(".user-real");
      realUsers.remove();
      this.users = {};
      return p.done(function(users) {
        var user, _i, _len, _results;

        _results = [];
        for (_i = 0, _len = users.length; _i < _len; _i++) {
          user = users[_i];
          _results.push(userView.append(_this.userSetup(user)));
        }
        return _results;
      });
    };

    Cpanel.prototype.userSetup = function(user, userMarkup) {
      var detailsAction, eventSetup, nextAction, nextActionMarkup, prevAction, prevActionMarkup, userActions, userEmail, userFIO, userId, userPhone, userStatus,
        _this = this;

      this.users[user.id] = user;
      if (!userMarkup) {
        eventSetup = true;
        userMarkup = $(".repo-user");
        userMarkup = userMarkup.clone().removeClass("hide");
        userMarkup.removeClass("repo-user");
        userMarkup.attr("user_id", "" + user.id);
      }
      userId = userMarkup.find(".user-id");
      userId.text(user.id);
      userFIO = userMarkup.find(".user-fio");
      userFIO.text("" + user.surname + " " + user.name + " " + user.patronymic);
      userEmail = userMarkup.find(".user-email");
      userEmail.text(user.email);
      userEmail.attr("href", "mailto:" + user.email);
      userPhone = userMarkup.find(".user-phone");
      userPhone.text(user.phone);
      userStatus = userMarkup.find(".user-status");
      userStatus.text(statuses[user.status]);
      userMarkup.addClass("user-real");
      userActions = userMarkup.find(".user-actions");
      nextAction = statusGraph.next[user.status];
      prevAction = statusGraph.prev[user.status];
      nextActionMarkup = userActions.find(".user-action-nextstate");
      prevActionMarkup = userActions.find(".user-action-prevstate");
      if (nextAction) {
        nextActionMarkup.parent().removeClass("hide");
      } else {
        nextActionMarkup.parent().addClass("hide");
      }
      if (prevAction) {
        prevActionMarkup.parent().removeClass("hide");
      } else {
        prevActionMarkup.parent().addClass("hide");
      }
      if (nextAction) {
        nextActionMarkup.text(statuses[nextAction]);
      }
      if (prevAction) {
        prevActionMarkup.text(statuses[prevAction]);
      }
      detailsAction = userActions.find("user-action-details");
      detailsAction.unbind().click(function() {
        return _this.userDetails(user.id);
      });
      prevActionMarkup.unbind().click(function() {
        return _this.userStatus(user.id, prevAction);
      });
      nextActionMarkup.unbind().click(function() {
        return _this.userStatus(user.id, nextAction);
      });
      return userMarkup;
    };

    Cpanel.prototype.userDetails = function(id) {};

    Cpanel.prototype.userStatus = function(id, status) {
      var p, user, userMarkup,
        _this = this;

      userMarkup = $(".user-real[user_id=\"" + id + "\"]");
      user = new User;
      user.fromData(this.users[id]);
      p = user.update(id, status);
      return p.done(function() {
        p = user.getById(id);
        return p.done(function(user) {
          return _this.userSetup(user, userMarkup);
        });
      });
    };

    return Cpanel;

  })();

  module.exports = Cpanel;

}).call(this);
