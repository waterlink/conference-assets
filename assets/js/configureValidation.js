// Generated by CoffeeScript 1.3.3
(function() {

  window.validation = {
    acceptFileTypes: /(rtf|docx?)$/i,
    maxNumberOfFiles: void 0,
    maxFileSize: void 0,
    minFileSize: void 0
  };

  ko.validation.configure({
    decorateElement: true,
    parseInputAttributes: true
  });

  ko.validation.rules.email.message = "Введите корректный email";

  ko.validation.rules.required.message = "Заполните обязательное поле";

  ko.validation.rules.fileUpload = {
    fileTypeNotAllowed: "Недопустимый формат файла",
    numberOfFilesExceeded: "Превышен лимит на количество файлов",
    fileTooSmall: "Размер файла слишком мал",
    fileTooBig: "Размер файла слишком большой"
  };

}).call(this);
