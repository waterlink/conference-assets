// Generated by CoffeeScript 1.6.1
(function() {
  var Restfull, xmlhttprequest,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  if (!global.$) {
    global.$ = require("jquery");
  }

  if (!global.XMLHttpRequest) {
    xmlhttprequest = require("xmlhttprequest").XMLHttpRequest;
    global.XMLHttpRequest = xmlhttprequest.XMLHttpRequest;
  }

  global.domain = "http://conference.lan";

  if (window) {
    global.domain = "";
  }

  Function.prototype.property = function(prop, desc) {
    return Object.defineProperty(this.prototype, prop, desc);
  };

  Restfull = (function(_super) {

    __extends(Restfull, _super);

    function Restfull() {
      return Restfull.__super__.constructor.apply(this, arguments);
    }

    Restfull.prototype.getWithoutId = function(entity, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity,
        type: "get",
        data: data,
        dataType: "json"
      });
    };

    Restfull.prototype.getWithId = function(entity, id, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity + "/" + id,
        type: "get",
        data: data,
        dataType: "json"
      });
    };

    Restfull.prototype.putWithoutId = function(entity, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity,
        type: "put",
        data: JSON.stringify(data),
        dataType: "json"
      });
    };

    Restfull.prototype.putWithId = function(entity, id, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity + "/" + id,
        type: "put",
        data: JSON.stringify(data),
        dataType: "json"
      });
    };

    Restfull.prototype.postWithoutId = function(entity, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity,
        type: "post",
        data: JSON.stringify(data),
        dataType: "json"
      });
    };

    Restfull.prototype.postWithId = function(entity, id, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity + "/" + id,
        type: "post",
        data: JSON.stringify(data),
        dataType: "json"
      });
    };

    Restfull.prototype.deleteWithoutId = function(entity, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity,
        type: "delete",
        data: JSON.stringify(data),
        dataType: "json"
      });
    };

    Restfull.prototype.deleteWithId = function(entity, id, data) {
      return $.ajax({
        url: "" + domain + this.prefix + "/" + entity + "/" + id,
        type: "delete",
        data: JSON.stringify(data),
        dataType: "json"
      });
    };

    Restfull.prototype.get = function(url, data) {
      var entity, id, _ref;
      if (url == null) {
        url = "";
      }
      if (data == null) {
        data = {};
      }
      this._saveLastRequest("get", url, data);
      _ref = this._urlPartify(url), entity = _ref[0], id = _ref[1];
      return this._withId(id, entity, data, this.getWithId, this.getWithoutId);
    };

    Restfull.prototype.put = function(url, data) {
      var entity, id, _ref;
      if (url == null) {
        url = "";
      }
      if (data == null) {
        data = {};
      }
      this._saveLastRequest("put", url, data);
      _ref = this._urlPartify(url), entity = _ref[0], id = _ref[1];
      return this._withId(id, entity, data, this.putWithId, this.putWithoutId);
    };

    Restfull.prototype.post = function(url, data) {
      var entity, id, _ref;
      if (url == null) {
        url = "";
      }
      if (data == null) {
        data = {};
      }
      this._saveLastRequest("post", url, data);
      _ref = this._urlPartify(url), entity = _ref[0], id = _ref[1];
      return this._withId(id, entity, data, this.postWithId, this.postWithoutId);
    };

    Restfull.prototype["delete"] = function(url, data) {
      var entity, id, _ref;
      if (url == null) {
        url = "";
      }
      if (data == null) {
        data = {};
      }
      this._saveLastRequest("delete", url, data);
      _ref = this._urlPartify(url), entity = _ref[0], id = _ref[1];
      return this._withId(id, entity, data, this.deleteWithId, this.deleteWithoutId);
    };

    return Restfull;

  })(Backend);

  module.exports = Restfull;

}).call(this);
