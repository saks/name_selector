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
    @_renderWithLayout new NameSelector.Views.SelectSex

  _renderWithLayout: (mainPageTemplate)->
    mainPageContent = mainPageTemplate.render().$el.html()
    layout = new NameSelector.Views.Layout pageContent: mainPageContent
    $('#app').html layout.render().$el



# views
class NameSelector.Views.Layout extends Backbone.View
  template: HandlebarsTemplates.layout
  render: ->
    html = @template
      home: 'Home',
      about: 'About',
      main_page_header: 'Подбор имени ребёнка',
      yield: @options.pageContent
    @$el.html html
    @


class NameSelector.Views.SelectSex extends Backbone.View
  template: HandlebarsTemplates.select_sex
  render: ->
    html = @template start: 'Начнём!', boy: 'Мальчик', girl: 'Девочка'
    @$el.html html
    @


jQuery NameSelector.init
