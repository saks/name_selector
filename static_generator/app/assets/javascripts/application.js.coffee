#= require jquery
#= require bootstrap-button
#= require bootstrap-dropdown
#= require underscore
#= require backbone
#= require backbone.localStorage
#= require handlebars.runtime
#= require_tree ./templates


window.NameSelector =
  Models:      {}
  Collections: {}
  Routes:      {}
  Views:       {}
  init: ->
    AllNames.reset [{text: 'Alex', id: '1'}, {text: 'Peter', id: '2'}]
    NameSelector.app = new NameSelector.Routes.Names
    Backbone.history.start()


window.Storage = Storage =
  empty: ->
    localStorage.length <= 0

  keyForScore: (score)->
    "names-with-score-#{score}"

  idsWithScore: (score)->
    ((ids = localStorage.getItem Storage.keyForScore(score)) && ids.split ',') || []

  hasScore: (id, score)->
    id = id + ''

    (ids = Storage.idsWithScore(score)).length > 0 && (_.indexOf(ids, id) >= 0)

  removeFromScores: (id, score)->
    id = id + ''

    if score > 0
      ids = Storage.idsWithScore score

      if ids.length > 0
        index = _.indexOf ids, id
        ids.splice index, 1
        localStorage.setItem Storage.keyForScore(score), _.uniq(ids).join(',')

  addToScores: (id, score)->
    id = id + ''

    if score > 0
      ids = Storage.idsWithScore score
      ids.push id
      localStorage.setItem Storage.keyForScore(score), _.uniq(ids).join(',')

# models
class Name extends Backbone.Model
  score: ->
    if score = @get('score')
      return score

    id = @get 'id'

    if !Storage.empty()
      return i for i in [1..10] when Storage.hasScore(id, i)

    0

  up: ->
    oldScore = @score()
    newScore = oldScore + 1
    id       = @get('id')

    @set 'score', newScore
    Storage.removeFromScores id, oldScore
    Storage.addToScores id, newScore

  down: ->
    oldScore = @score()
    newScore = oldScore - 1
    id       = @get('id')

    @set 'score', newScore
    Storage.removeFromScores id, oldScore
    Storage.addToScores id, newScore


# collections
PersistedNames = Backbone.Collection.extend
  model: Name
  localStorage: new Backbone.LocalStorage('name-selector')

NotPersistedNames = Backbone.Collection.extend
  model: Name

window.AllNames = new NotPersistedNames



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
