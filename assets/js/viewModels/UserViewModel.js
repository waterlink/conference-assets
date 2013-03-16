// Generated by CoffeeScript 1.6.1
(function() {

  window.UserViewModel = (function() {

    function UserViewModel(user) {
      var _this = this;
      _.extend(this, user);
      this.fullName = ko.computed(function() {
        return "" + (_this.surname || '') + " " + (_this.name || '') + " " + (_this.patronymic || '');
      });
      this.job = ko.computed(function() {
        return "" + (_this.jobPosition || '') + " в " + (_this.jobTitle || '');
      });
      this.monography = ko.computed(function() {
        return _this.monographyTitle || "-";
      });
      this.downloadLink = ko.computed(function() {
        return "http://google.com?q=архивчик";
      });
    }

    return UserViewModel;

  })();

}).call(this);
