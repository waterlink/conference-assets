//@ sourceMappingURL=UserRegistrationViewModel.map
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
      this.user = this.addValidation({
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
        stayStart: ko.observable(new Date),
        stayEnd: ko.observable(new Date)
      });
      this.errors = ko.validation.group(this.user);
      this.errorAlert = new Alert("#needFixErrors");
    }

    UserRegistrationViewModel.prototype.doRegister = function() {
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

    UserRegistrationViewModel.prototype.addValidation = function(user) {
      this.makeFieldsRequired(user);
      user.email.extend({
        email: true
      });
      return user;
    };

    UserRegistrationViewModel.prototype.makeFieldsRequired = function(user) {
      var isRequired, key, value;
      for (key in user) {
        value = user[key];
        isRequired = true;
        if (key === "stayStart" || key === "stayEnd") {
          isRequired = {
            onlyIf: user.stayDemand
          };
        }
        if (key === "monographyTitle") {
          isRequired = {
            onlyIf: user.monographyParticipant
          };
        }
        if (key === "monographyParticipant" || key === "stayDemand") {
          isRequired = false;
        }
        value.extend({
          required: isRequired
        });
      }
      user.stayDemand.subscribe(function(value) {
        ko.validation.validateObservable(user.stayStart);
        return ko.validation.validateObservable(user.stayEnd);
      });
      return user.monographyParticipant.subscribe(function(value) {
        return ko.validation.validateObservable(user.monographyTitle);
      });
    };

    return UserRegistrationViewModel;

  })();

}).call(this);
