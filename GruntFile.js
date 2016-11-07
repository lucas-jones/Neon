module.exports = function (grunt)
{
	var PORT =  grunt.option('port') || 8080;
	var IP =  grunt.option('ip') || '127.0.0.1';

	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-haxe');
	grunt.loadNpmTasks('grunt-concurrent');
	grunt.loadNpmTasks('grunt-contrib-connect');

	grunt.initConfig(
	{
		connect:
		{
			local_server:
			{
				options:
				{
					port: PORT,
					base: 'bin',
					livereload: true,
					debug: false,
					hostname: IP,
					open:
					{
						target: 'http://' + IP + ':' + PORT
					}
				}
			}
		},

		copy:
		{
			main:
			{
				files: [{
							cwd: 'assets/',
							expand: true,
							src: [ '**', "!spritesheets/**" ],
							dest: 'bin/assets'
						}]
			}
		},

		haxe:
		{
			main:
			{
				hxml: 'build.hxml'
			}
		},

		watch:
		{
			options:
			{
				livereload: true,
				livereloadOnError: false,
			},
			haxe:
			{
				files: '**/*.hx',
				tasks: ['haxe:main']
			}
		},

		concurrent:
		{
			options:
			{
			   logConcurrentOutput: true
			},
			watch:
			{
				tasks: [ "watch:haxe", "connect" ]
			}
		},
	});


	grunt.registerTask('build', ['copy', 'haxe:main']);
	grunt.registerTask('default', ['build', 'connect', 'watch']);
}