conference-assets
=================

Conference project. Assets git submodule.

TODO
====

 * 
   make User model through TDD (jasmine) without backend: 
   just use mockup object instead of backend -- it will work with list in memory of browser
   this mockup object must be passed to constructor of User (as a real backend class would be in real ride)
   User has:
     1 name
     2 surname
     3 patronymic name
     4 participant (true=participant/false=listener)
     5 status (new/emailsent/paid)
   User must:
     1 create
     2 get by id
     3 get list of users (using skip and limit for paging)
     4 get list of users filtered (listener/participant; new/emailsent/paid)
     5 update status
