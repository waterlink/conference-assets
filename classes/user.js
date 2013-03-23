// Generated by CoffeeScript 1.3.3
(function() {
  var User;

  global.Restfull = require("../classes/restfull");

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
      this.uploadId = false;
    }

    User.prototype.fromData = function(data) {
      this.id = data.id;
      this.name = data.name;
      this.surname = data.surname;
      this.patronymic = data.patronymic;
      this.participant = data.participant;
      this.academicDegree = data.academicDegree;
      this.academicTitle = data.academicTitle;
      this.jobPosition = data.jobPosition;
      this.jobPlace = data.jobPlace;
      this.city = data.city;
      this.country = data.country;
      this.postalAddress = data.postalAddress;
      this.email = data.email;
      this.phone = data.phone;
      this.participantType = data.participantType;
      this.lectureTitle = data.lectureTitle;
      this.sectionNumber = data.sectionNumber;
      this.monographyParticipant = data.monographyParticipant;
      this.stayDemand = data.stayDemand;
      if (this.monographyParticipant) {
        this.monographyTitle = data.monographyTitle;
      }
      if (this.stayDemand) {
        this.stayStart = data.stayStart;
        this.stayEnd = data.stayEnd;
      }
      return this.uploadId = data.uploadId;
    };

    User.prototype.getData = function() {
      var res;
      res = {
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
        stayDemand: this.stayDemand,
        uploadId: this.uploadId
      };
      if (this.monographyParticipant) {
        res["monographyTitle"] = this.monographyTitle;
      }
      if (this.stayDemand) {
        res["stayStart"] = this.stayStart;
        res["stayEnd"] = this.stayEnd;
      }
      return res;
    };

    User.prototype.create = function() {
      return this.backend.post("user", this.getData());
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
      this.status = status;
      return this.backend.put(["user", "" + id], this.getData());
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
