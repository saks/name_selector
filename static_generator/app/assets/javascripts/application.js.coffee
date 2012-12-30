#= require jquery
#= require i18n/translations
#= require bootstrap-button
#= require bootstrap-dropdown
#= require underscore
#= require backbone
#= require backbone.localStorage
#= require handlebars.runtime
#= require_tree ./templates
#= require storage
#= require backbone_app
#= require name


# routing
class NameSelector.Routes.Names extends Backbone.Router
  routes:
    '': 'select_sex'
    'select': 'select_names'

  select_sex: ->
    @renderLayout()
    (new NameSelector.Views.SelectSex).render()

  select_names: ->
    @renderLayout()
    (new NameSelector.Views.Names).render()

  renderLayout: ->
    (new NameSelector.Views.Layout).render()

T = NameSelector.T = -> I18n.translations[NameSelector.currentLocale]

# views
class NameSelector.Views.Layout extends Backbone.View
  el: '#app'
  template: HandlebarsTemplates.layout
  render: ->
    html = @template
      main_page_header:  T().main_page_header
      back_to_main_page: T().back_to_main_page
      is_main_page:      '' == location.hash
    @$el.html html
    @


class NameSelector.Views.SelectSex extends Backbone.View
  el: '.main'
  events:
    'click .select-sex': 'startNameSelection'

  template: HandlebarsTemplates.select_sex
  render: ->
    html = @template start: T().lets_begin, boy: T().boy, girl: T().girl
    @$el.html html
    @

  startNameSelection: (event)->
    NameSelector.sex = $(event.currentTarget).data 'sex'
    NameSelector.app.navigate 'select', trigger: true


class NameSelector.Views.Names extends Backbone.View
  el: '.main'
  events:
    'click #names': 'toggle'
  template: HandlebarsTemplates.names
  render: ->
    @$el.html @template()
    @addAll()
    @

  addAll: ->
    AllNames.each @addOne

  addOne: (name)->
    (new NameSelector.Views.Name model: name).render()

  toggle: (event)->
    button = $(event.target)
    nameId = button.data 'id'
    button.toggleClass 'btn-primary'
    AllNames.get(nameId)[if button.hasClass 'active' then 'down' else 'up']()


class NameSelector.Views.Name extends Backbone.View
  el: '#names'
  template: HandlebarsTemplates.name
  render: ->
    @$el.append @template(@model.attributes)
    @

jQuery NameSelector.init
