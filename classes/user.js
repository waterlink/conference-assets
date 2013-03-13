// Generated by CoffeeScript 1.6.1
(function() {
  var User;

  User = (function() {

    function User(name, surname, patronymic, _deprecated_participant, status) {
      this.name = name != null ? name : "";
      this.surname = surname != null ? surname : "";
      this.patronymic = patronymic != null ? patronymic : "";
      this._deprecated_participant = _deprecated_participant != null ? _deprecated_participant : "";
      this.status = status != null ? status : "new";
      this.backend = new Restfull;
      this.academicDegree = "";
      this.academicTitle = "";
      this.jobPosition = "";
      this.jobPlace = "";
      this.city = "";
      this.country = "";
      this.postalAddress = "";
      this.email = "";
      this.phone = "";
      this.participantType = "";
      this.lectureTitle = "";
      this.sectionNumber = "";
      this.monographyParticipant = false;
      this.stayDemand = false;
    }

    User.prototype.create = function() {
      var url;
      return url = this.backend.post("user", {
        name: this.name,
        surname: this.surname,
        patronymic: this.patronymic,
        participant: this.participant,
        status: this.status,
        academicDegree: this.academicDegree,
        academicTitle: this.academicTitle,
        jobPosition: this.jobPosition,
        jobPlace: this.jobPlace,
        city: this.city,
        country: this.country,
        postalAddress: this.postalAddress,
        email: this.email,
        phone: this.phone,
        participantType: this.participantType,
        lectureTitle: this.lectureTitle,
        sectionNumber: this.sectionNumber,
        monographyParticipant: this.monographyParticipant,
        stayDemand: this.stayDemand
      });
    };

    User.prototype.getById = function(id) {
      return this.backend.get(["user", "" + id]);
    };

    User.prototype.list = function() {
      return this.backend.get("user");
    };

    User.prototype.listFiltered = function(skip, limit) {
      var data;
      if (skip == null) {
        skip = void 0;
      }
      if (limit == null) {
        limit = void 0;
      }
      data = {};
      if (this.participant !== void 0) {
        data.participant = this.participant;
      }
      if (this.status !== void 0) {
        data.status = this.status;
      }
      data.skip = skip;
      data.limit = limit;
      return this.backend.get("user", data);
    };

    User.prototype.update = function(id, status) {
      return this.backend.put(["user", String(id)], {
        status: status
      });
    };

    User.prototype.setup = function(backend) {
      this.backend = backend;
    };

    User.prototype.setMonographyParticipant = function(monographyParticipant, monographyTitle) {
      this.monographyParticipant = monographyParticipant != null ? monographyParticipant : true;
      this.monographyTitle = monographyTitle != null ? monographyTitle : "";
    };

    User.prototype.setStayDemand = function(stayDemand, stayStart, stayEnd) {
      this.stayDemand = stayDemand != null ? stayDemand : true;
      this.stayStart = stayStart != null ? stayStart : "";
      this.stayEnd = stayEnd != null ? stayEnd : "";
    };

    return User;

  })();

  module.exports = User;

}).call(this);
