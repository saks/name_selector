window.NameSelector =
  currentLocale: 'ru'
  currentNameScore: 0
  removeMode: false
  Models:      {}
  Collections: {}
  Routes:      {}
  Views:       {}
  init: ->
    AllNames.reset [{text: 'Alex', id: '1'}, {text: 'Peter', id: '2'}]
    NameSelector.app = new NameSelector.Routes.Names
    Backbone.history.start()
