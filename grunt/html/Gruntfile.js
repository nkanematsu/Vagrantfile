module.exports = function(grunt) {
  grunt.initConfig({
    ftpush: {
      build: {
        auth: {
          host: '192.168.33.11',
          port: 21,
          authKey: 'ftp'
        },
        src: '',
        dest: '/tmp/',
        exclusions: ['.*','node_modules/*','**/Thumbs.db','Gruntfile.js','dist/tmp'],
        keep: [],
        simple: true,
        useList: false
      }
    },
    watch: {
      'ftpush':{
        files: ['**/*.php','**/*.css','**/*.js'],
        tasks: ['ftpush']
      }
    },
  });
 
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-ftpush');
 
  grunt.registerTask('default', ['watch','ftpush']);
};
