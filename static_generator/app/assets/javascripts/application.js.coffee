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
    $.get '/name/female/', (names) ->
      normalizedNames = []
      for id, name of names
        normalizedNames.push id: id, text: name

      AllNames.reset normalizedNames

      NameSelector.sex = $(event.currentTarget).data 'sex'
      NameSelector.app.navigate 'select', trigger: true


class NameSelector.Views.Names extends Backbone.View
  el: '.main'
  events:
    'click #names': 'toggle'
    'click .select_scope': 'changeScope'
    'click .start-removing a': 'startRemoving'
    'click .stop-removing a': 'stopRemoving'

  template: HandlebarsTemplates.names
  render: ->
    currentNameScore = Storage.getCurrentNameScore()

    @$el.html @template(
      select_for: 'Выбираем имя для '
      sex: 'мальчика'
      boy: 'мальчика'
      girl: 'девочки'
      from: ' из '
      names_scope: T().scope[currentNameScore]
      removeModeEnabled: currentNameScore > 0
      canUpNames: currentNameScore < 5
      removeMode: NameSelector.removeMode
    )
    @addAll()
    @

  addAll: ->
    _.each Name.withScore(Storage.getCurrentNameScore()), @addOne

  addOne: (name)->
    (new NameSelector.Views.Name model: name).render()

  toggle: (event)->
    return if 5 == Storage.getCurrentNameScore() && !NameSelector.removeMode


    button = $(event.target)
    nameId = button.data 'id'


    if nameId
      klass = if true == NameSelector.removeMode then 'btn-danger' else 'btn-success'
      button.toggleClass klass

      methodName = if 'btn-danger' == klass
        if button.hasClass(klass) then 'down' else 'up'
      else if 'btn-success' == klass
        if button.hasClass(klass) then 'up' else 'down'

      AllNames.get(nameId)[methodName]()

  changeScope: (event)->
    target = @$ event.target
    score  = (if target.hasClass 'select_scope' then target else target.parent()).data 'score'
    Storage.setCurrentNameScore score
    @render()

  startRemoving: ->
    NameSelector.removeMode = true
    @render()

  stopRemoving: ->
    NameSelector.removeMode = false
    @render()


class NameSelector.Views.Name extends Backbone.View
  el: '#names'
  template: HandlebarsTemplates.name
  render: ->
    @$el.append @template(@model.attributes)
    @

jQuery NameSelector.init
