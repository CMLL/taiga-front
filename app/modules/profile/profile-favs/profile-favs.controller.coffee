debounceLeading = @.taiga.debounceLeading

class FavsBaseController
    constructor: ->
        @._init()
        #@._getItems = null # Define in inheritance classes

    _init: ->
        @._resetList()
        @.q = null
        @.type = null

    _resetList: ->
        @.items = Immutable.List()
        @.hasNoMorePages = false
        @._page = 1

    _enableLoadingSpinner: ->
        @.isLoading = true

    _disableLoadingSpinner: ->
        @.isLoading = false

    _checkIfHasMorePages: (hasNext)->
        if hasNext
            @.hasNoMorePages = true
            @._page += 1
        else
            @.hasNoMorePages = false

    _checkIfHasNoResults: ->
        @.hasNoResults = @.items.size == 0

    loadItems:  ->
        @._enableLoadingSpinner()

        @._getItems(@.user.get("id"), @._page, @.type, @.q)
            .then (response) =>
                @.items = @.items.concat(response.get("data"))

                @._checkIfHasMorePages(response.get("next"))
                @._checkIfHasNoResults()
                @._disableLoadingSpinner()

                return @.items

    ################################################
    ## Filtre actions
    ################################################
    filterByTextQuery: debounceLeading 500, ->
        @._resetList()
        @.loadItems()

    showAll: ->
        if @.type isnt null
            @.type = null
            @._resetList()
            @.loadItems()

    showProjectsOnly: ->
        if @.type isnt "project"
            @.type = "project"
            @._resetList()
            @.loadItems()

    showUserStoriesOnly: ->
        if @.type isnt "userstory"
            @.type = "userstory"
            @._resetList()
            @.loadItems()

    showTasksOnly: ->
        if @.type isnt "task"
            @.type = "task"
            @._resetList()
            @.loadItems()

    showIssuesOnly: ->
        if @.type isnt "issue"
            @.type = "issue"
            @._resetList()
            @.loadItems()


####################################################
## Likes
####################################################

class ProfileLikesController extends FavsBaseController
    @.$inject = [
        "tgUserService",
    ]

    constructor: (@userService) ->
        super()
        @._getItems = @userService.getLikes


angular.module("taigaProfile")
    .controller("ProfileLikes", ProfileLikesController)


####################################################
## Watched
####################################################

class ProfileWatchedController extends FavsBaseController
    @.$inject = [
        "tgUserService",
    ]

    constructor: (@userService) ->
        super()
        @._getItems = @userService.getWatched


angular.module("taigaProfile")
    .controller("ProfileWatched", ProfileWatchedController)

