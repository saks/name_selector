#= require jquery
#= require bootstrap-button
#= require underscore
#= require backbone
#= require backbone.localStorage
#= require handlebars.runtime
#= require_tree ./templates


window.NameSelector =
  Models:      {}
  Controllers: {}
  Collections: {}
  Routes:      {}
  Views:       {}
  init: ->
    AllNames.reset [{text: 'Alex', id: '1'}, {text: 'Peter', id: '2'}]
    NameSelector.app = new NameSelector.Routes.Names
    Backbone.history.start()




# models
class Name extends Backbone.Model
  defaults:
    score: 0
  up: ->
    @set 'score', @get('score') + 1
  down: ->
    @set 'score', @get('score') - 1

# collections
PersistedNames = Backbone.Collection.extend
  model: Name
  localStorage: new Backbone.LocalStorage('name-selector')

NotPersistedNames = Backbone.Collection.extend
  model: Name
  # localStorage: new Backbone.LocalStorage('name-selector')

window.AllNames = new NotPersistedNames
# window.Names1 = new PersistedNames
# window.Names2 = new PersistedNames
# window.Names3 = new PersistedNames
# window.Names4 = new PersistedNames
# window.Names5 = new PersistedNames
# window.Names6 = new PersistedNames



NameSelector.Collections.Names = new Backbone.Collection.extend(model: NameSelector.Models.Name)

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



# views
class NameSelector.Views.Layout extends Backbone.View
  el: '#app'
  template: HandlebarsTemplates.layout
  render: ->
    html = @template
      home: 'Home',
      about: 'About',
      main_page_header: 'Подбор имени ребёнка',
    @$el.html html
    @


class NameSelector.Views.SelectSex extends Backbone.View
  el: '.main'
  events:
    'click .select-sex': 'startNameSelection'

  template: HandlebarsTemplates.select_sex
  render: ->
    html = @template start: 'Начнём!', boy: 'Мальчик', girl: 'Девочка'
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
