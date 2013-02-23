conference-assets
=================

Conference project. Assets git submodule.

TODO
====

 * make User model through TDD (jasmine) without backend: 
   just use mockup object instead of backend -- it will work with list in memory of browser
   it has:
     > name
     > surname
     > patronymic name
     > participant (true=participant/false=listener)
     > status (new/emailsent/paid)
   it must:
     > create
     > get by id
     > get list of users (using skip and limit for paging)
     > get list of users filtered (listener/participant; new/emailsent/paid)
     > update status
