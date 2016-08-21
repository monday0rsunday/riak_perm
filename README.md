### Test project for reproduce permgen OOM with Riak

* do not care about other files in this project (because they are used for buidling/running project immediately), except for

  * `src/main/java/com/broship/user/service/ContextListener.java`
  * `src/main/resources/webapp/WEB-INF/web.xml`

### Updating code

* Just uncomment as I wrote

### Building

* change `JETTY_USER`, `JETTY_GROUP` in `script/riak_perm.sh` to your user/group
* exec `./gradle build`
* change to run dir `cd build/distribution`
* start Jetty `./bin/riak_perm.sh start`, and remember enter your user password
* start some JVM tool like VisualVM
* fake update your webapp by `touch server/webapps/riak_perm-v0.xml` for 1,2,3, etc times
* see perm gen always increase!
