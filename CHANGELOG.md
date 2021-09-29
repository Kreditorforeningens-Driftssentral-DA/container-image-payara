# CHANGELOG

## BUILD 5.2021.7-11
#### CHANGES (2021-09-29)
  * Payara version 5.2021.7
  * Packer build refactor/cleanup

## BUILD 5.2021.6-11
#### CHANGES (2021-08-25)
  * Re-added logback configfile-path during provisioning: /tmp/logback.xml (req. domain restart after it is set)
#### CHANGES (2021-08-25)
  * Removed logback files/settings.. Add at runtime instead.
  * Removed some other exernal libraries & applications. Add at runtime instead, using pre/post-boot.
#### IMPROVEMENTS (2021-08-24)
  * Added logback as default logging driver

