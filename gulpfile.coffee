gulp = require 'gulp'
nib = require 'nib'
express = require 'express'

browserify = require 'browserify'
watchify = require 'watchify'
coffeeify = require 'coffeeify'

source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'

cache = require 'gulp-cached'
stylus = require 'gulp-stylus'
reload = require 'gulp-livereload'
concat = require 'gulp-concat'
autowatch = require 'gulp-autowatch'

# paths
paths =
  img: './client/img/**/*'
  bundle: './client/index.coffee'
  html: './client/**/*.html'
  stylus: './client/**/*.styl'


# javascript
args =
  fullPaths: true
  cache: {}
  packageCache: {}
  extensions: ['.coffee']

bundler = watchify browserify paths.bundle, args
bundler.transform coffeeify

bundle = ->
  bundler.bundle()
    .once 'error', (err) ->
      console.error err.message
    .pipe source 'index.js'
    .pipe buffer()
    .pipe cache 'js'
    .pipe gulp.dest './public'
    .pipe reload()


gulp.task 'html', ->
  gulp.src paths.html
    .pipe cache 'html'
    .pipe gulp.dest './public'
    .pipe reload()

gulp.task 'img', ->
  gulp.src paths.img
    .pipe cache 'img'
    .pipe gulp.dest './public/img'
    .pipe reload()

gulp.task 'stylus', ->
  gulp.src paths.stylus
    .pipe stylus
      use: nib()
    .pipe concat 'index.css'
    .pipe gulp.dest './public'
    .pipe reload()


gulp.task 'server', (cb) ->
  app = express()
  app.use express.static "#{__dirname}/public"
  app.get '/*', (req, res) ->
    res.sendFile "#{__dirname}/public/index.html"
  app.listen 9090
  cb()


gulp.task 'js', bundle

gulp.task 'watch', (cb) ->
  reload.listen()
  bundler.on 'update', gulp.parallel 'js'
  autowatch gulp, paths
  cb()

gulp.task 'build', gulp.parallel 'js', 'stylus', 'html', 'img'
gulp.task 'default', gulp.series 'server', 'build', 'watch'
