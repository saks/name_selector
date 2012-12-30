//= require jquery
//= require underscore
//= require backbone
//= require handlebars.runtime
//= require_tree ./templates


window.NameSelector =
  Models:      {}
  Controllers: {}
  Routes:      {}
  Views:       {}
  init: ->
    new NameSelector.Routes.Names
    Backbone.history.start()



# models
class window.NameSelector.Models.Name extends Backbone.Model

# routing
class NameSelector.Routes.Names extends Backbone.Router
  routes:
    '': 'select_sex'

  select_sex: ->
    view = new NameSelector.Views.SelectSex()
    $('.app').html view.render().$el


# views
class NameSelector.Views.SelectSex extends Backbone.View
  render: ->
    html = HandlebarsTemplates.select_sex start: 'Начнём!', boy: 'Мальчик', girl: 'Девочка'
    @$el.html html
    @


jQuery -> NameSelector.init()
