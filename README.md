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


- describe backend
   * it should return acccess denied error when guest trying to access not user collection
   * it should return acccess denied error when guest trying to access not index collection
   * it should be allowed for [guest, operator] to [post with id, get, put without id, delete] to index
   * it should change authenticatedAs when post to index/#{operator.login}
   * it should return group of current operator: one of [guest, operator, admin] when get index
   * it should change password when put without id to index
   * it should logoff when delete index
   * it should be allowed for guest to [post without id] to user
   * it should be allowed for [admin] to [*all methods*] to *
   * it should reset password to new when put with id = operator.login to index
   * it should register new operator when post without id to index

### Dependencies for developer

- node.js
- npm
- coffeescript
- jasmine-node
- lodash
- browserify
