// Generated by CoffeeScript 1.6.1
(function() {

  window.UserViewModel = (function() {

    function UserViewModel(user) {
      var _this = this;
      _.extend(this, user);
      this.fullName = ko.computed(function() {
        return "" + (_this.surname || '') + " " + (_this.name || '') + " " + (_this.patronymic || '');
      });
      this.status = ko.observable(this.status);
      this.locStatus = ko.computed(function() {
        return statuses[_this.status()];
      });
      this.mailto = ko.computed(function() {
        return "mailto:" + _this.email;
      });
      this.nextStatus = ko.computed(function() {
        return statuses[statusGraph.next[_this.status()]];
      });
      this.prevStatus = ko.computed(function() {
        return statuses[statusGraph.prev[_this.status()]];
      });
      this.fullJob = ko.computed(function() {
        return "" + _this.jobPosition + " в " + _this.jobPlace + " г. " + _this.city + ", " + _this.country;
      });
      this.z_monographyTitle = ko.computed(function() {
        return _this.monographyTitle || "";
      });
      this.z_stayStart = ko.computed(function() {
        return (_this.stayStart || "").replace(/T.*/, "");
      });
      this.z_stayEnd = ko.computed(function() {
        return (_this.stayEnd || "").replace(/T.*/, "");
      });
      this.isMonographyParticipant = ko.computed(function() {
        return _this.monographyParticipant && _this.monographyParticipant !== "0";
      });
      this.isStayDemand = ko.computed(function() {
        return _this.stayDemand && _this.stayDemand !== "0";
      });
    }

    UserViewModel.prototype.details = function() {
      return cpanel.userDetails(this.id);
    };

    UserViewModel.prototype.goNextStatus = function() {
      var nextAction, onError, p,
        _this = this;
      nextAction = statusGraph.next[this.status()];
      if (nextAction) {
        p = cpanel.userStatus(this.id, nextAction);
        $(".user-table-row[user_id=\"" + this.id + "\"] .user-actions .dropdown-toggle").button("loading");
        onError = function() {
          return $(".user-table-row[user_id=\"" + _this.id + "\"] .user-actions .dropdown-toggle").button("error");
        };
        p.done(function(e) {
          var user;
          if (e && e.error) {
            return onError();
          }
          user = new User;
          p = user.getById(_this.id);
          p.done(function(user) {
            if (!user || user.error) {
              return onError();
            }
            _this.status(user.status);
            return $(".user-table-row[user_id=\"" + _this.id + "\"] .user-actions .dropdown-toggle").button("reset");
          });
          return p.error(onError);
        });
        return p.error(onError);
      }
    };

    UserViewModel.prototype.goPrevStatus = function() {
      var onError, p, prevAction,
        _this = this;
      prevAction = statusGraph.prev[this.status()];
      if (prevAction) {
        p = cpanel.userStatus(this.id, prevAction);
        $(".user-table-row[user_id=\"" + this.id + "\"] .user-actions .dropdown-toggle").button("loading");
        onError = function() {
          return $(".user-table-row[user_id=\"" + _this.id + "\"] .user-actions .dropdown-toggle").button("error");
        };
        p.done(function(e) {
          var user;
          if (e && e.error) {
            return onError();
          }
          user = new User;
          p = user.getById(_this.id);
          p.done(function(user) {
            if (!user || user.error) {
              return onError();
            }
            _this.status(user.status);
            return $(".user-table-row[user_id=\"" + _this.id + "\"] .user-actions .dropdown-toggle").button("reset");
          });
          return p.error(onError);
        });
        return p.error(onError);
      }
    };

    return UserViewModel;

  })();

  module.exports = window.UserViewModel;

}).call(this);
