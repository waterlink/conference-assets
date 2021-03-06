// Generated by CoffeeScript 1.6.2
(function() {
  global.Restfull = require("../classes/restfull");

  window.UserViewModel = (function() {
    function UserViewModel(user) {
      var _this = this;

      _.extend(this, user);
      this.surname = ko.observable(this.surname);
      this.name = ko.observable(this.name);
      this.patronymic = ko.observable(this.patronymic);
      this.fullName = ko.computed({
        read: function() {
          return "" + (_this.surname() || '') + " " + (_this.name() || '') + " " + (_this.patronymic() || '');
        },
        write: function(v) {
          var words;

          words = v.split(" ").filter(function(x) {
            return x;
          });
          _this.surname(words[0] || _this.surname());
          _this.name(words[1] || _this.name());
          return _this.patronymic(words[2] || _this.patronymic());
        }
      });
      this.academicDegree = ko.observable(this.academicDegree);
      this.academicTitle = ko.observable(this.academicTitle);
      this.jobPosition = ko.observable(this.jobPosition);
      this.jobPlace = ko.observable(this.jobPlace);
      this.city = ko.observable(this.city);
      this.country = ko.observable(this.country);
      this.postalAddress = ko.observable(this.postalAddress);
      this.email = ko.observable(this.email);
      this.phone = ko.observable(this.phone);
      this.participantType = ko.observable(this.participantType);
      this.lectureTitle = ko.observable(this.lectureTitle);
      this.sectionNumber = ko.observable(this.sectionNumber);
      this.status = ko.observable(this.status);
      this.sent = ko.observable(this.sent);
      this._stayStart = ko.observable(this.stayStart ? new Date(this.stayStart) : "");
      this._stayEnd = ko.observable(this.stayEnd ? new Date(this.stayEnd) : "");
      this.extract = function(d) {
        return [d.getMonth() + 1, d.getDate(), d.getFullYear()];
      };
      this.stayStart = ko.computed({
        read: function() {
          if (_this._stayStart()) {
            return _this.extract(_this._stayStart()).join('/');
          } else {
            return "";
          }
        },
        write: function(v) {
          return _this._stayStart(v);
        }
      });
      this.stayEnd = ko.computed({
        read: function() {
          if (_this._stayEnd()) {
            return _this.extract(_this._stayEnd()).join('/');
          } else {
            return "";
          }
        },
        write: function(v) {
          return _this._stayEnd(v);
        }
      });
      this.stayPeriod = ko.computed(function() {
        return "" + (_this.stayStart()) + " - " + (_this.stayEnd());
      });
      this.z_thesisPay = ko.computed(function() {
        return "" + searchData.thesisCost + searchData.costCurrency;
      });
      this.z_organizationPay = ko.computed(function() {
        if (_this.participantType() === "Очная") {
          return "" + searchData.organizationCost + searchData.costCurrency;
        } else {
          return 0;
        }
      });
      this.z_monographyPay = ko.computed(function() {
        if (_this.monographyParticipant && _this.monographyPay) {
          return "" + _this.monographyPay + searchData.costCurrency;
        } else {
          return 0;
        }
      });
    }

    return UserViewModel;

  })();

  module.exports = window.UserViewModel;

}).call(this);
