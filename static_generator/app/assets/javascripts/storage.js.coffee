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

