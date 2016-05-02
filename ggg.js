// example ggg.js. Delete what you don't need
module.exports = {

  // services
  start: "node_modules/coffee-script/bin/coffee app.coffee",

  // install
  install: "npm install && node_modules/coffee-script/bin/coffee -c static/js/*.coffee",

  // servers to deploy to
  servers: {
    prod: "root@192.241.216.160"
  }
}
