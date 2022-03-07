# CHANGELOG

## 2022-03-07
  * Removed auto-builds: 2021.1.Alpha1, 5.2021.9, 5.2021.8
  * Added auto-builds: 5.2022.1
  * Updated postgres-jdbc: 42.3.3

## 2022-01-28
  * Combined docker-build/push actions; removed schedule for individual actions; updated labels.

## 2022-01-27
  * New action for build/push to GitHub packages.
  * Renamed build action(s).

## 2022-01-23
  * Updated mssql jdbc driver to latest version & triggered action/build.
  * Changed pipeline to only trigger manually & on schedule.

## BUILD 6.2021.1-11 (Alpha)
#### CHANGES (2021-11-11)
  * New Payara version (Alpha)
  * Added scheduled Github Action for building Payara v6

## BUILD 5.2021.8-11
#### CHANGES (2021-11-11)
  * New Payara version
  * Changed "extra-vars" to "env-vars" in ansible provisioning step. In earlier config, values were not picked up from packer (used defaults from playbook).

## BUILD 5.2021.7-11
#### CHANGES (2021-09-29)
  * Change to dumb-init instead of tini
  * Add "JAVA_TOOL_OPTIONS" as global variable (e.g. passing '-XX:MaxRAMPercentage' when using non-root user)
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
