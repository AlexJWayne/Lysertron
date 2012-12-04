mocha.setup('bdd')
chai.should()

$ ->
  $('body').append $('<div>').attr(id: 'mocha')
  mocha.run()