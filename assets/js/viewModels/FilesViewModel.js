// Generated by CoffeeScript 1.6.1
(function() {

  window.FilesViewModel = (function() {

    function FilesViewModel() {
      this.data = ko.observableArray();
    }

    FilesViewModel.prototype.formatSize = function(bytes) {
      var GB, KB, MB, _ref;
      _ref = [1024, 1024 * 1024, 1024 * 1024 * 1024], KB = _ref[0], MB = _ref[1], GB = _ref[2];
      if (typeof bytes !== 'number') {
        return "";
      } else if (bytes >= GB) {
        return "" + ((bytes / GB).toFixed(2)) + " GB";
      } else if (bytes >= MB) {
        return "" + ((bytes / MB).toFixed(2)) + " MB";
      } else if (bytes >= KB) {
        return "" + ((bytes / KB).toFixed(2)) + " KB";
      } else {
        return "" + bytes + " B";
      }
    };

    FilesViewModel.prototype.remove = function(file) {
      var f, _i, _len, _ref;
      this.data.remove(file);
      _ref = this.data();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        f = _ref[_i];
        f.error = "";
      }
      return this.validate(this.data());
    };

    FilesViewModel.prototype.localize = function(text) {
      switch (text) {
        case "Filetype not allowed":
          return ko.validation.rules.fileUpload.fileTypeNotAllowed;
        case "Maximum number of files exceeded":
          return ko.validation.rules.fileUpload.numberOfFilesExceeded;
        case "File is too small":
          return ko.validation.rules.fileUpload.fileTooSmall;
        case "File is too big":
          return ko.validation.rules.fileUpload.fileTooBig;
      }
    };

    FilesViewModel.prototype.validate = function() {};

    return FilesViewModel;

  })();

}).call(this);
