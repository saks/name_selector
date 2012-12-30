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

PersistedNames = Backbone.Collection.extend
  model: Name
  localStorage: new Backbone.LocalStorage('name-selector')

NotPersistedNames = Backbone.Collection.extend
  model: Name

window.AllNames = new NotPersistedNames



NameSelector.Collections.Names = new Backbone.Collection.extend(model: NameSelector.Models.Name)