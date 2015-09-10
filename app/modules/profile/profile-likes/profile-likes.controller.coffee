debounceLeading = @.taiga.debounceLeading


class ProfileLikesController
    @.$inject = [
        "tgUserService",
    ]

    constructor: (@userService) ->
        @._resetList()
        @.q = null
        @.type = null

    _resetList: ->
        @.likes = Immutable.List()
        @.scrollDisabled = false
        @._page = 1

    loadLikes: () ->
        @.scrollDisabled = true

        @userService.getLikes(@.user.get("id"), @._page, @.type, @.q)
            .then (response) =>
                @.likes = @.likes.concat(response.get("data"))

                if response.get("next")
                    @.scrollDisabled = false
                    @._page += 1

                return @.likes

    ################################################
    ## Filtre
    ################################################
    filterByTextQuery: debounceLeading 100, ->
        @._resetList()
        @.loadLikes()

    showAll: ->
        if @.type isnt null
            @.type = null
            @._resetList()
            @.loadLikes()

    showProjectsOnly: ->
        if @.type isnt "project"
            @.type = "project"
            @._resetList()
            @.loadLikes()

    showUserStoriesOnly: ->
        if @.type isnt "userstory"
            @.type = "userstory"
            @._resetList()
            @.loadLikes()

    showTasksOnly: ->
        if @.type isnt "task"
            @.type = "task"
            @._resetList()
            @.loadLikes()

    showIssuesOnly: ->
        if @.type isnt "issue"
            @.type = "issue"
            @._resetList()
            @.loadLikes()


angular.module("taigaProfile")
    .controller("ProfileLikes", ProfileLikesController)

