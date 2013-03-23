// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require("../classes/restfull");

  window.RegistrationViewModel = (function() {

    function RegistrationViewModel() {
      this.isAvailableDateToStay = __bind(this.isAvailableDateToStay, this);

      var _this = this;
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
        stayStart: ko.observable(new Date(this.start)),
        stayEnd: ko.observable(new Date(this.end))
      };
      this.files = new FilesViewModel;
      this.searchData = window.searchData;
      this.errors = ko.validation.group(this.user);
      this.errorAlert = new Alert("#needFixErrors");
      this.rest = new Restfull("");
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
    }

    RegistrationViewModel.prototype.doRegister = function() {
      var button, creating, p;
      if (!this.hasValidation) {
        this.addValidation();
      }
      if (this.errors().length === 0) {
        console.log(ko.mapping.toJS(this.user));
        creating = new User;
        creating.fromData(ko.mapping.toJS(this.user));
        creating.uploadId = this.files.uploadId();
        p = creating.create();
        button = $(".form-signin .btn-primary");
        button.button("loading");
        return p.done(function(data) {
          if (data) {
            if (data.error) {
              alert(data.error);
              button.button("reset");
              return;
            }
          }
          button.button("reset");
          return global.location = "success.html";
        });
      } else {
        this.errorAlert.show();
        return this.errors.showAllMessages();
      }
    };

    RegistrationViewModel.prototype.isAvailableDateToStay = function(date) {
      console.log(date);
      return true;
    };

    RegistrationViewModel.prototype.addValidation = function() {
      this.makeFieldsRequired();
      return this.hasValidation = true;
    };

    RegistrationViewModel.prototype.makeFieldsRequired = function() {
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

    return RegistrationViewModel;

  })();

}).call(this);
