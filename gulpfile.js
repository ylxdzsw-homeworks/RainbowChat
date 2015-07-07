var gulp         = require("gulp"),
	autoprefixer = require("gulp-autoprefixer"),
	cache        = require("gulp-cached"),
	coffee       = require("gulp-coffee"),
	coffeelint   = require("gulp-coffeelint"),
	cjsx         = require("gulp-cjsx"),
	less         = require("gulp-less"),
	minifyCss    = require("gulp-minify-css"),
	notify       = require("gulp-notify"),
	rename       = require("gulp-rename"),
	uglify       = require("gulp-uglify"),
	sourcemaps   = require("gulp-sourcemaps"),
	del          = require("del"),
	fs           = require('fs');

var helper = {
	coffee: function(globs,dest){
		return function(){
			return gulp.src(globs)
				//.pipe(coffeelint())
				//.pipe(coffeelint.reporter())
				.pipe(cache('coffee'))
				.pipe(rename({extname:".js"}))
				.pipe(sourcemaps.init())
					.pipe(coffee())
					.on('error', console.log)
					.pipe(uglify())
				.pipe(sourcemaps.write())
				.pipe(gulp.dest(dest))
				.pipe(notify({message: "a coffee task complete"}));
		};
	},
	less: function(globs,dest){
		return function(){
			return gulp.src(globs)
				.pipe(cache('less'))
				.pipe(rename({extname:'.css'}))
				.pipe(sourcemaps.init())
					.pipe(less())
					.on('error', console.log)
					.pipe(autoprefixer({browsers:['last 2 versions']}))
					.pipe(minifyCss())
				.pipe(sourcemaps.write())
				.pipe(gulp.dest(dest))
				.pipe(notify({message: "a less task complete"}));
		};
	},
	cjsx: function(globs, dest){
		return function(){
			return gulp.src(globs)
				.pipe(cache('cjsx'))
				.pipe(sourcemaps.init())
					.pipe(cjsx({bare:true}))
					.on('error', console.log)
					.pipe(uglify())
				.pipe(sourcemaps.write())
				.pipe(gulp.dest(dest))
				.pipe(notify({message: "a cjsx task complete"}));
		}
	},
	copy: function(globs, dest){
		return function(){
			return gulp.src(globs)
				//.pipe(cache('asset'))
				.pipe(gulp.dest(dest))
				.pipe(notify({message: "copy done"}))
		};
	},
	globs: {
		root: "*.coffee",
		bin: "bin/*.coffee",
		rest: "rest/**/*.coffee",
		midl: "middleware/**/*.coffee",
		util: "util/*.coffee",
		page_script: "page/**/*.coffee",
		page_cjsx: "page/**/*.cjsx",
		page_style: "page/**/*.less",
		page_other: ['page/**/*','!page/**/*.coffee', '!page/**/*.less', "!page/**/*.cjsx"],
		config_script: "config/*.coffee",
		config_json: "config/*.json",
		asset: "start"
	}
}

gulp.task('clean', function(cb){
	del(['build'], cb);
	notify("cleaning finished");
});

gulp.task('root', helper.coffee(helper.globs.root, "build/"));

gulp.task('bin', helper.coffee(helper.globs.bin, "build/bin/"));

gulp.task('rest', helper.coffee(helper.globs.rest, "build/rest/"));

gulp.task('midl', helper.coffee(helper.globs.midl, "build/middleware/"));

gulp.task('util', helper.coffee(helper.globs.util, "build/util/"));

gulp.task('page_script', helper.coffee(helper.globs.page_script, 'build/page/'));

gulp.task('page_cjsx', helper.cjsx(helper.globs.page_cjsx, 'build/page/'));

gulp.task('page_style', helper.less(helper.globs.page_style, 'build/page/'));

gulp.task('page_copier', helper.copy(helper.globs.page_other, 'build/page/'));

gulp.task('config_script', helper.coffee(helper.globs.config_script, 'build/config/'));

gulp.task('config_json', helper.copy(helper.globs.config_json, 'build/config/'));

gulp.task('asset', helper.copy(helper.globs.asset, 'build'));

gulp.task('log', function(){
	return fs.mkdir('build/log',0777,function(err){
		if(err){
			notify(err);
		}else{
			notify("creating log complete");
		}
	});
});

gulp.task('make', ['root', 'bin', 'rest', 'midl', 'util'/*, 'watch'*/, 'page_script', 'page_cjsx', 'page_style', 'page_copier', 'config_script', 'config_json', 'asset', 'log'], function(){
	notify("all task done!");
});

gulp.task('default', ['make']);

gulp.task('watch', function(){
	gulp.watch(helper.globs.root,['root']);
	gulp.watch(helper.globs.bin,['bin']);
	gulp.watch(helper.globs.rest,['rest']);
	gulp.watch(helper.globs.midl,['midl']);
	gulp.watch(helper.globs.util,['util']);
	gulp.watch(helper.globs.page_script,['page_script']);
	gulp.watch(helper.globs.page_cjsx,['page_cjsx']);
	gulp.watch(helper.globs.page_style,['page_style']);
	gulp.watch(helper.globs.page_other,['page_copier']);
	gulp.watch(helper.globs.config_script,['config_script']);
	gulp.watch(helper.globs.config_json,['config_json']);
	gulp.watch(helper.globs.asset,['asset']);
});