// Generated by CoffeeScript 1.6.1
(function() {
  var _this = this;

  window.UserRegistrationViewModel = (function() {

    function UserRegistrationViewModel() {
      var _this = this;
      this.isAvailableDateToStay = function(date) {
        return UserRegistrationViewModel.prototype.isAvailableDateToStay.apply(_this, arguments);
      };
      this.start = new Date;
      this.end = new Date;
      this.start.setDate(this.start.getDate() - 7);
      this.end.setDate(this.end.getDate() + 7);
      this.user = {
        name: ko.observable(""),
        surname: ko.observable(""),
        patronymic: ko.observable(""),
        academicDegree: ko.observable(""),
        academicTitle: ko.observable(""),
        jobPosition: ko.observable(""),
        jobPlace: ko.observable(""),
        city: ko.observable(""),
        country: ko.observable("Украина"),
        postalAddress: ko.observable(""),
        email: ko.observable(""),
        phone: ko.observable(""),
        participantType: ko.observable(""),
        lectureTitle: ko.observable(""),
        sectionNumber: ko.observable(""),
        monographyParticipant: ko.observable(false),
        monographyTitle: ko.observable(""),
        stayDemand: ko.observable(false),
        stayStart: ko.observable(""),
        stayEnd: ko.observable("")
      };
      this.searchData = window.searchData;
      this.errors = ko.validation.group(this.user);
      this.errorAlert = new Alert("#needFixErrors");
    }

    UserRegistrationViewModel.prototype.doRegister = function() {
      if (!this.hasValidation) {
        this.addValidation();
      }
      if (this.errors().length === 0) {
        return console.log(ko.mapping.toJS(this.user));
      } else {
        this.errorAlert.show();
        return this.errors.showAllMessages();
      }
    };

    UserRegistrationViewModel.prototype.isAvailableDateToStay = function(date) {
      console.log(date);
      return true;
    };

    UserRegistrationViewModel.prototype.addValidation = function() {
      this.makeFieldsRequired();
      this.user.email.extend({
        email: {
          message: "Введите корректный email",
          params: true
        }
      });
      return this.hasValidation = true;
    };

    UserRegistrationViewModel.prototype.makeFieldsRequired = function() {
      var isRequired, key, value, _ref,
        _this = this;
      _ref = this.user;
      for (key in _ref) {
        value = _ref[key];
        if (!(value.extend != null)) {
          continue;
        }
        isRequired = true;
        if (key === "stayStart" || key === "stayEnd") {
          isRequired = {
            onlyIf: this.user.stayDemand
          };
        }
        if (key === "monographyTitle") {
          isRequired = {
            onlyIf: this.user.monographyParticipant
          };
        }
        if (key === "monographyParticipant" || key === "stayDemand") {
          isRequired = false;
        }
        if (value != null) {
          value.extend({
            required: isRequired
          });
        }
      }
      this.user.stayDemand.subscribe(function(value) {
        ko.validation.validateObservable(_this.user.stayStart);
        return ko.validation.validateObservable(_this.user.stayEnd);
      });
      return this.user.monographyParticipant.subscribe(function(value) {
        return ko.validation.validateObservable(_this.user.monographyTitle);
      });
    };

    return UserRegistrationViewModel;

  })();

}).call(this);
