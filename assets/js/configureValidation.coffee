window.validation =
    acceptFileTypes:  /(jpg|jpeg|png|bmp|gif|tif|pdf|rtf|doc|docx?)$/i
    maxNumberOfFiles: undefined
    maxFileSize:      undefined
    minFileSize:      undefined


ko.validation.configure
    decorateElement:      yes
    parseInputAttributes: yes

ko.validation.rules.email.message = "Введите корректный email"
ko.validation.rules.required.message = "Заполните обязательное поле"

ko.validation.rules.fileUpload =
    fileTypeNotAllowed: "Недопустимый формат файла"
    numberOfFilesExceeded: "Превышен лимит на количество файлов"
    fileTooSmall: "Размер файла слишком мал"
    fileTooBig: "Размер файла слишком большой"
