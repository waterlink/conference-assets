conference-assets
=================

Conference project. Assets git submodule.

### TODO

- [ __DONE__ ]  make User model through TDD (jasmine) without backend:
just use mockup object instead of backend -- it will work with list in memory of browser
this mockup object must be passed to constructor of User (as a real backend class would be in real ride)

   * User has:
      1. name
      2. surname
      3. patronymic name
      4. participant (true=participant/false=listener)
      5. status (new/emailsent/paid)
   * User must:
      1. create
      2. get by id
      3. get list of users (using skip and limit for paging)
      4. get list of users filtered (listener/participant; new/emailsent/paid)
      5. update status


- [ __DONE__ ] describe backend (authentication)
   * xit should return acccess denied error when guest trying to access not user collection
   * [ __WRONG__ ] it should not return acccess denied error when guest trying to access index collection
   * xit should be allowed for [guest] to [post with id] to index
   * xit should be allowed for [operator] to [post with id, get, put without id, delete] to index
   * xit should be allowed for [guest] to [post without id] to user
   * xit should be disallowed for [guest] to [post with id] to user
   * xit should be disallowed for [guest] to [get, post with id, put, delete] to user
   * xit should change authenticatedAs when post to index/#{operator.login}
   * xit should return group of current operator: one of [guest, operator, admin] when get index
      - will return json: {whois: "{operator.login}", group: "{list of [guest, operator, admin]}"}
   * xit should change password when put without id to index
      - data would be json: {old_password: "{old_password}", new_password: "{new_password}"}
   * xit should logoff when delete index
   * xit should be allowed for [admin] to [*all methods*] to *
   * xit should reset password to new when put with id = operator.login to index
   * xit should register new operator when post without id to index

- [ __DONE__ ] remove "participant" field from user class

### Dependencies for developer

- node.js
- npm
- coffeescript
- jasmine-node
- lodash
- browserify

### Interface specifications (RU)

__Форма регистрации__

Поля, которые должны быть в форме регистрации :

_добавлены в фронтенд в TDD_

- ФИО участника
- Научная степень (Миша даст список вариантов, когда точно узнает у них)
- Ученое звание (Миша даст список вариантов, когда точно узнает у них)
- Должность
- Место работы
- Город (Стяну базу городов, при наборе будет выдавать, fuzzy поиск)
- Страна (Украина по-умолчанию, иначе выбор стран)
- Почтовый адрес (Обязательное поле, нужна какая-то валидация?)
- Электронный адрес (Обязательное уникальное поле, идентификация пользователя)
- Телефон (Обязателен, подтверждения нет по телефону)
- Форма участия в конференции (Спросить у Миши, что это и какие варианты)
- Название доклада
- Номер секции (Нужно взять у них номера секций и соответствующие дисциплины по секциями, выбор с fuzzy поиском)
- Участие в монографии (да, нет)
- Название раздела монографии (Нужно взять список монографий)
- Потребность в проживании (даты) (чекбокс, есть ли потребность, и вываливается два няшных календарика, анально ограниченные по дням конференции +/- 2 дня)
- Поле для загрузки документов (doc, docx, rtf; макс. кол-во документов ограничено (3-5?)), к каждому документу комментарии

__Какие нужны виды по регистрации__

- Вид пустой формы регистрации:
   * Участие в монографии не отмечено, соответственно, поле «Название раздела монографии» скрыто
   * Потребность в проживании не отмечено, соответственно, два календарика не отображены
- Отмечено «Участие в монографии»
   * кусок формы при отображенном «Название раздела монографии», захватить соседние элементы формы для понимания вида




